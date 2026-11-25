import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/logger/log.dart';
import '../../../../core/extensions/app_localization.dart';
import '../../../../core/extensions/failure_localization.dart';
import '../../../../domain/entities/door_lock_entity.dart';
import '../../../../domain/entities/facility_entity.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../core/widgets/app_text_field.dart';
import '../riverpod/door_lock_action_provider.dart';
import '../riverpod/door_status_provider.dart';
import '../riverpod/facility_attendants_provider.dart';
import '../riverpod/facility_gates_provider.dart';
import '../riverpod/door_opening_reason_provider.dart';
import '../riverpod/door_states_provider.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../core/widgets/menu_item_app_bar.dart';
import '../../../../domain/entities/menu_item_key.dart';
import '../../../../domain/entities/partner_staff_entity.dart';
import '../../../../data/models/door_status_model.dart';

part '../widgets/door_action_buttons.dart';
part '../widgets/door_status_card.dart';
part '../widgets/primary_device_card.dart';
part '../widgets/reason_selector.dart';
part '../widgets/unlock_success_banner.dart';
part '../widgets/usage_type_selector.dart';

enum _UsageType { personal, customer }

class DoorControlPage extends ConsumerStatefulWidget {
  const DoorControlPage({super.key, required this.facility});

  final FacilityEntity facility;

  @override
  ConsumerState<DoorControlPage> createState() => _DoorControlPageState();
}

class _DoorControlPageState extends ConsumerState<DoorControlPage> {
  _UsageType _usageType = _UsageType.customer;
  GateData? _selectedGate;
  DoorOpeningReason? _selectedReason;
  late final TextEditingController _authCodeController;
  PartnerStaffEntity? _selectedAttendant;
  bool _isFacilityOnline = true;

  String get _facilityId => widget.facility.id.toString();

  bool get _isReadyToUnlock {
    final hasAuthCode = _authCodeController.text.isNotEmpty;
    final hasUsageConfig = switch (_usageType) {
      _UsageType.customer => _selectedGate != null,
      _UsageType.personal => _selectedGate != null,
    };
    return hasAuthCode && hasUsageConfig;
  }

  bool get _isReadyToUnlockPersonal {
    if (_usageType != _UsageType.personal) return false;
    return _selectedReason != null && _selectedAttendant != null;
  }

  String _summary(BuildContext context) => switch (_usageType) {
    _UsageType.customer =>
      '${context.locale.customerUse} '
          '(${_selectedGate?.getLocalizedTitle(Localizations.localeOf(context).languageCode) ?? ''} — ${context.numbers.currency(_selectedGate?.price ?? 0)})',
    _UsageType.personal =>
      '${context.locale.personalUse} (${_selectedGate?.getLocalizedTitle(Localizations.localeOf(context).languageCode) ?? ''})',
  };

  @override
  void initState() {
    super.initState();
    _authCodeController = TextEditingController();
    _loadAuthCode();
    _checkFacilityHealth();
  }

  Future<void> _checkFacilityHealth() async {
    try {
      final gatewayService = ref.read(gatewayServiceProvider);
      final result = await gatewayService.healthCheck();
      setState(() => _isFacilityOnline = result);
      Log.info(_isFacilityOnline ? '✅ Facility online' : '❌ Facility offline');
    } catch (e) {
      setState(() => _isFacilityOnline = false);
      Log.warning('⚠️ Health check failed: $e');
    }
  }

  Future<void> _loadAuthCode() async {
    final prefs = await SharedPreferences.getInstance();
    final savedAuthCode = prefs.getString('door_auth_code') ?? '';
    _authCodeController.text = savedAuthCode;
    Log.info('📂 Loaded auth code from storage: ${savedAuthCode.isNotEmpty ? '***' : 'empty'}');
  }

  Future<void> _saveAuthCode(String authCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('door_auth_code', authCode);
    Log.info('💾 Saved auth code to storage');
  }

  bool _getGateLockStatus(GateData gate, List<DoorStatusModel> doorStatuses) {
    try {
      final doorStatus = doorStatuses.firstWhere(
        (door) => door.door == gate.deviceId,
      );
      Log.info('✅ Found gate status: gate=${gate.deviceId}, isClosed=${doorStatus.isClosed}');
      return doorStatus.isClosed;
    } catch (e) {
      Log.warning('⚠️ Gate status not found: gate=${gate.deviceId}, available doors=${doorStatuses.map((d) => d.door).toList()}');
      return true; // Default to locked if not found
    }
  }

  @override
  void dispose() {
    _authCodeController.dispose();
    super.dispose();
  }

  void _onUsageTypeChanged(_UsageType type) {
    setState(() {
      _usageType = type;
      _selectedGate = null;
      _selectedReason = null;
    });
  }

  void _onUnlock() {
    Log.info('🔓 _onUnlock CALLED');
    final authCode = _authCodeController.text;
    final useValue = _usageType == _UsageType.customer ? 'customer' : 'personal';
    final doorValue = _usageType == _UsageType.customer
        ? _selectedGate?.gender ?? 'male'
        : _selectedGate?.deviceId ?? 'unknown';

    Log.info('🔓 Fresh door status check before unlock');

    // Invalidate polling cache and get fresh data
    ref.refresh(doorStatesPollingProvider((_facilityId, authCode)));

    // Wait briefly then read fresh polling data
    Future.delayed(const Duration(milliseconds: 500)).then((_) {
      final freshData = ref.read(doorStatesPollingProvider((_facilityId, authCode)));

      freshData.maybeWhen(
        data: (states) {
          final states_ = states as List<DoorStatusModel>;
          DoorStatusModel? currentDoor;
          try {
            currentDoor = states_.firstWhere(
              (door) => door.door == _selectedGate?.deviceId,
            );
          } catch (e) {
            currentDoor = null;
          }

          Log.info('✅ Fresh check: door=${currentDoor?.door}, isClosed=${currentDoor?.isClosed}');

          if (currentDoor != null && !currentDoor.isClosed) {
            Log.warning('⚠️ Door is open! Blocking unlock');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Door is already open. Cannot unlock.'),
                backgroundColor: context.color.warning,
                duration: const Duration(seconds: 3),
              ),
            );
            return;
          }

          Log.info('✅ Door is locked. Proceeding with unlock');
          _proceedWithUnlock(authCode, doorValue, useValue);
        },
        orElse: () {
          Log.warning('⚠️ Could not validate, proceeding');
          _proceedWithUnlock(authCode, doorValue, useValue);
        },
      );
    });
  }

  void _proceedWithUnlock(String authCode, String doorValue, String useValue) {
    final purposeValue = _selectedReason?.key;
    final amountValue = _usageType == _UsageType.customer
        ? _selectedGate?.price.toInt()
        : null;
    final attendantName = _usageType == _UsageType.personal ? _selectedAttendant?.name : null;
    final attendantId = _usageType == _UsageType.personal ? _selectedAttendant?.id : null;

    Log.info('🔓 Unlock - use: $useValue, door: $doorValue, purpose: $purposeValue, attendant: $attendantName');

    ref.read(doorLockActionProvider.notifier).unlock(
          facilityId: _facilityId,
          summary: _summary(context),
          authCode: authCode,
          door: doorValue,
          use: useValue,
          amount: amountValue,
          purpose: purposeValue,
          attendant: attendantName,
          attendantId: attendantId,
        );
  }


  @override
  Widget build(BuildContext context) {
    ref.listen(doorLockActionProvider, (previous, next) {
      if (next.hasError && !next.isLoading) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!.localizedMessage(context)),
            backgroundColor: context.color.error,
          ),
        );
      } else if (next.hasValue && next.value != null && !next.isLoading) {
        // Save auth code and navigate to result page
        _saveAuthCode(_authCodeController.text);
        final result = next.value!;
        Log.info('✅ Unlock success! Navigating to result page');
        Future.microtask(() {
          context.pushNamed(
            'door-control/result',
            extra: result,
          );
        });
      }
    });

    final authCode = _authCodeController.text;
    final doorStatesAsync = _isReadyToUnlock
        ? ref.watch(doorStatesPollingProvider((_facilityId, authCode)))
        : const AsyncValue.data(<DoorStatusModel>[]);
    final actionState = ref.watch(doorLockActionProvider);

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: MenuItemAppBar(
        itemKey: MenuItemKey.doorLock,
        fallbackTitle: context.locale.doorControl,
      ),
      body: Column(
        children: [
          if (!_isFacilityOnline)
            Container(
              color: context.color.warning,
              padding: EdgeInsets.all(context.dimensions.padding.p16),
              child: Row(
                children: [
                  Icon(Icons.wifi_off, color: context.color.onPrimary, size: 20),
                  Gap(context.dimensions.spacing.s8),
                  Expanded(
                    child: Text(
                      'Facility Offline - Read Only Mode',
                      style: context.textStyle.bodySmall.copyWith(
                        color: context.color.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: doorStatesAsync.when(
        data: (doorStates) {
          final states = doorStates as List<DoorStatusModel>;
          final matchingDoor = states.isNotEmpty
              ? states.firstWhere(
                  (door) => door.door == (_selectedGate?.deviceId ?? ''),
                  orElse: () => states.first,
                )
              : null;
          final isLocked = matchingDoor?.isClosed ?? true;

          Log.info('🚪 Door State: door=${matchingDoor?.door}, isClosed=${matchingDoor?.isClosed}, locked=${matchingDoor?.locked}');

          return _buildBody(context, isLocked, actionState, states, _isFacilityOnline);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) =>
            Center(child: Text(error.localizedMessage(context))),
      ),
            ),
        ],
      ),
    );
  }

  Widget _buildDoorStatusCard(BuildContext context) {
    final dimensions = context.dimensions;
    final authCode = _authCodeController.text;
    final doorStatesAsync = authCode.isNotEmpty
        ? ref.watch(doorStatesPollingProvider((_facilityId, authCode)))
        : const AsyncValue.loading();

    return doorStatesAsync.when(
      data: (doorStates) {
        final states = doorStates as List<DoorStatusModel>;
        DoorStatusModel? matchingStatus;
        if (_selectedGate != null && states.isNotEmpty) {
          matchingStatus = states.firstWhere(
            (state) => state.door == _selectedGate!.deviceId,
            orElse: () => states.first,
          );
        }

        Log.info('🚪 Door Status: selected=${_selectedGate?.deviceId}, '
            'status=${matchingStatus?.door}, isClosed=${matchingStatus?.isClosed}');

        return _DoorStatusCard(
          isLocked: matchingStatus?.isClosed ?? true,
          isCached: false,
          doorName: _selectedGate?.getLocalizedTitle(
            Localizations.localeOf(context).languageCode,
          ),
          doorStatus: matchingStatus,
        );
      },
      loading: () => _DoorStatusCard(
        isLocked: true,
        isCached: false,
        doorName: _selectedGate?.getLocalizedTitle(
          Localizations.localeOf(context).languageCode,
        ),
      ),
      error: (_, __) => _DoorStatusCard(
        isLocked: true,
        isCached: true,
        doorName: _selectedGate?.getLocalizedTitle(
          Localizations.localeOf(context).languageCode,
        ),
      ),
    );
  }

  Widget _buildAuthCodeField(
    BuildContext context,
    Dimensions dimensions,
    bool isLoading,
  ) {
    return AppTextField.password(
      label: 'Auth Code',
      controller: _authCodeController,
      enabled: !isLoading,
      hint: 'Enter facility auth code',
    );
  }

  Widget _buildServiceSelector(
    BuildContext context,
    Dimensions dimensions,
    bool isLoading,
    List<DoorStatusModel> doorStatuses,
  ) {
    final gatesAsync = ref.watch(facilityGatesProvider(_facilityId));
    final locale = Localizations.localeOf(context).languageCode;

    Log.info('🚪 _buildServiceSelector called, doorStatuses count: ${doorStatuses.length}');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'DOOR',
          style: context.textStyle.labelLarge.copyWith(
            color: context.color.text.primary,
          ),
        ),
        Gap(dimensions.spacing.s4),
        Text(
          context.locale.selectDoorToOpen,
          style: context.textStyle.bodyMedium.copyWith(
            color: context.color.text.secondary,
          ),
        ),
        Gap(dimensions.spacing.s12),
        gatesAsync.when(
          data: (gates) {
            // Auto-select first gate if none selected
            if (_selectedGate == null && gates.isNotEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() => _selectedGate = gates.first);
              });
            }
            return _buildGateCards(context, dimensions, gates, doorStatuses, locale, isLoading);
          },
          loading: () => Center(
            child: SizedBox(
              height: 48,
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            ),
          ),
          error: (_, __) => Text(
            'Error loading gates',
            style: context.textStyle.bodyMedium.copyWith(
              color: context.color.error,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGateCards(
    BuildContext context,
    Dimensions dimensions,
    List<GateData> gates,
    List<DoorStatusModel> doorStatuses,
    String locale,
    bool isLoading,
  ) {
    Log.info('🎨 _buildGateCards: gates count=${gates.length}, doorStatuses count=${doorStatuses.length}');
    final cardWidth = gates.length == 1
        ? 200.0
        : (MediaQuery.of(context).size.width - (2 * dimensions.padding.p16) - (2 * dimensions.spacing.s16)) / 3;

    return Wrap(
      spacing: dimensions.spacing.s16,
      runSpacing: dimensions.spacing.s16,
      alignment: gates.length == 1 ? WrapAlignment.center : WrapAlignment.start,
      children: [
        for (final gate in gates)
          SizedBox(
            width: cardWidth,
            child: _buildGateCard(context, dimensions, gate, doorStatuses, locale, isLoading),
          ),
      ],
    );
  }

  Widget _buildGateCard(
    BuildContext context,
    Dimensions dimensions,
    GateData gate,
    List<DoorStatusModel> doorStatuses,
    String locale,
    bool isLoading,
  ) {
    final isLocked = _getGateLockStatus(gate, doorStatuses);
    Log.info('🎨 _buildGateCard: gate=${gate.deviceId}, isLocked=$isLocked, doorStatuses=${doorStatuses.length}, statusText=${isLocked ? "Locked" : "Open"}');

    return GestureDetector(
      onTap: isLoading ? null : () => setState(() => _selectedGate = gate),
      child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: EdgeInsets.all(dimensions.padding.p16),
              decoration: BoxDecoration(
                color: _selectedGate?.id == gate.id
                    ? context.color.primary
                    : context.color.onPrimary,
                border: Border.all(
                  color: _selectedGate?.id == gate.id
                      ? context.color.primary
                      : context.color.borderSubtle,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(dimensions.radius.r12),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        gate.gender == 'male' ? Icons.wc_outlined : Icons.wc_outlined,
                        size: 28,
                        color: _selectedGate?.id == gate.id
                            ? context.color.onPrimary
                            : context.color.text.primary,
                      ),
                      Gap(dimensions.spacing.s8),
                      Expanded(
                        child: Text(
                          gate.getLocalizedTitle(locale),
                          style: context.textStyle.labelMedium.copyWith(
                            color: _selectedGate?.id == gate.id
                                ? context.color.onPrimary
                                : context.color.text.primary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Status badge (top-left)
            Positioned(
              top: -8,
              left: -8,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: dimensions.spacing.s8,
                  vertical: dimensions.spacing.s4,
                ),
                decoration: BoxDecoration(
                  color: isLocked ? context.color.warning : context.color.success,
                  borderRadius: BorderRadius.circular(dimensions.radius.r12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  isLocked ? 'Locked' : 'Open',
                  style: context.textStyle.labelSmall.copyWith(
                    color: context.color.onPrimary,
                    fontWeight: TextWeight.bold,
                  ),
                ),
              ),
            ),
            if (_usageType == _UsageType.customer)
              Positioned(
                top: -8,
                right: -8,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: dimensions.spacing.s8,
                    vertical: dimensions.spacing.s4,
                  ),
                  decoration: BoxDecoration(
                    color: context.color.primary,
                    borderRadius: BorderRadius.circular(dimensions.radius.r12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    context.numbers.currency(gate.price.toInt()),
                    style: context.textStyle.labelSmall.copyWith(
                      color: context.color.onPrimary,
                      fontWeight: TextWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
  }

  List<Widget> _buildPersonalDetailsSection(BuildContext context, Dimensions dimensions, bool isLocked, bool isLoading) {
    if (_usageType != _UsageType.personal || !isLocked) {
      return [];
    }
    return [
      _buildAttendantSelector(context, dimensions, isLoading),
      Gap(dimensions.spacing.s16),
      _ReasonSelector(
        selected: _selectedReason,
        onSelect: isLoading
            ? null
            : (reason) => setState(() => _selectedReason = reason),
      ),
      Gap(dimensions.spacing.s16),
    ];
  }

  Widget _buildAttendantSelector(
    BuildContext context,
    Dimensions dimensions,
    bool isLoading,
  ) {
    final attendantsAsync = ref.watch(facilityAttendantsProvider(_facilityId));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ATTENDANT',
          style: context.textStyle.labelLarge.copyWith(
            color: context.color.text.primary,
          ),
        ),
        Gap(dimensions.spacing.s4),
        Text(
          context.locale.selectPersonWhoUseGate,
          style: context.textStyle.bodyMedium.copyWith(
            color: context.color.text.secondary,
          ),
        ),
        Gap(dimensions.spacing.s12),
        attendantsAsync.when(
          data: (attendants) => GestureDetector(
            onTap: isLoading || attendants.isEmpty
                ? null
                : () {
                    showModalBottomSheet<PartnerStaffEntity>(
                      context: context,
                      builder: (ctx) => ListView.builder(
                        shrinkWrap: true,
                        itemCount: attendants.length,
                        itemBuilder: (_, idx) => ListTile(
                          title: Text(attendants[idx].name),
                          selected: _selectedAttendant?.id == attendants[idx].id,
                          onTap: () {
                            setState(
                              () => _selectedAttendant = attendants[idx],
                            );
                            Navigator.pop(ctx);
                          },
                        ),
                      ),
                    );
                  },
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: dimensions.padding.p16,
                vertical: dimensions.padding.p16,
              ),
              decoration: BoxDecoration(
                color: context.color.onPrimary,
                borderRadius: BorderRadius.circular(dimensions.radius.r12),
                border: Border.all(
                  color: _selectedAttendant != null
                      ? context.color.primary
                      : context.color.borderSubtle,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedAttendant?.name ?? 'Select Attendant',
                    style: context.textStyle.bodyMedium.copyWith(
                      color: _selectedAttendant != null
                          ? context.color.text.primary
                          : context.color.text.secondary,
                    ),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    color: context.color.text.secondary,
                  ),
                ],
              ),
            ),
          ),
          loading: () => Container(
            padding: EdgeInsets.symmetric(
              horizontal: dimensions.padding.p16,
              vertical: dimensions.padding.p16,
            ),
            decoration: BoxDecoration(
              color: context.color.subtle,
              borderRadius: BorderRadius.circular(dimensions.radius.r12),
              border: Border.all(color: context.color.borderSubtle),
            ),
            child: const SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
          error: (_, __) => Container(
            padding: EdgeInsets.symmetric(
              horizontal: dimensions.padding.p16,
              vertical: dimensions.padding.p16,
            ),
            decoration: BoxDecoration(
              color: context.color.subtle,
              borderRadius: BorderRadius.circular(dimensions.radius.r12),
              border: Border.all(color: context.color.borderSubtle),
            ),
            child: Text(
              'Error loading attendants',
              style: context.textStyle.bodyMedium.copyWith(
                color: context.color.error,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBody(
    BuildContext context,
    bool isLocked,
    AsyncValue<DoorUnlockResult?> actionState,
    List<DoorStatusModel> doorStatuses,
    bool isOnline,
  ) {
    Log.info('📄 _buildBody called, isLocked=$isLocked, doorStatuses=${doorStatuses.length}');
    final dimensions = context.dimensions;
    final isLoading = actionState.isLoading;
    final isDisabled = isLoading || !isOnline;
    final unlockResult = actionState.valueOrNull;

    Log.info('📊 Door Lock State: isLocked=$isLocked, '
        'isLoading=$isLoading, '
        'unlockResult=$unlockResult, _isReadyToUnlock=$_isReadyToUnlock');
    Log.info('🔘 Unlock Button Can Enable: '
        'isLocked=$isLocked && '
        '_isReadyToUnlock=$_isReadyToUnlock && '
        '!isLoading=${!isLoading} = '
        '${isLocked && _isReadyToUnlock && !isLoading}');

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(dimensions.padding.p16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _PrimaryDeviceCard(
                  facility: widget.facility,
                  isOffline: !isOnline,
                ),
                Gap(dimensions.spacing.s16),
                _buildAuthCodeField(context, dimensions, isDisabled),
                Gap(dimensions.spacing.s16),
                _UsageTypeSelector(
                  selected: _usageType,
                  onSelect: isLoading ? null : _onUsageTypeChanged,
                ),
                Gap(dimensions.spacing.s16),
                _buildServiceSelector(context, dimensions, isDisabled, doorStatuses),
                Gap(dimensions.spacing.s16),
                ..._buildPersonalDetailsSection(context, dimensions, isLocked, isDisabled),
              ],
            ),
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              dimensions.padding.p16,
              0,
              dimensions.padding.p16,
              dimensions.padding.p16,
            ),
            child: _DoorActionButtons(
              canUnlock: isOnline && isLocked && _isReadyToUnlock && !isLoading && (_usageType == _UsageType.customer || _isReadyToUnlockPersonal),
              isUnlockLoading: isLoading && isLocked,
              isOffline: !isOnline,
              onUnlock: _onUnlock,
            ),
          ),
        ),
      ],
    );
  }
}
