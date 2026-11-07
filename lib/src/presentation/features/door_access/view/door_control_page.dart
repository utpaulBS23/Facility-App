import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

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

  String get _facilityId => widget.facility.id.toString();

  bool get _isReadyToUnlock {
    final hasAuthCode = _authCodeController.text.isNotEmpty;
    final hasUsageConfig = switch (_usageType) {
      _UsageType.customer => _selectedGate != null,
      _UsageType.personal =>
        _selectedGate != null &&
        _selectedReason != null &&
        _selectedAttendant != null,
    };
    return hasAuthCode && hasUsageConfig;
  }

  String _summary(BuildContext context) => switch (_usageType) {
    _UsageType.customer =>
      '${context.locale.customerUse} '
          '(${_selectedGate?.getLocalizedTitle(Localizations.localeOf(context).languageCode) ?? ''} — ${context.numbers.currency(_selectedGate?.price.toInt() ?? 0)})',
    _UsageType.personal =>
      '${context.locale.personalUse} (${_selectedReason?.name ?? ''})',
  };

  @override
  void initState() {
    super.initState();
    _authCodeController = TextEditingController();
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
    final useValue = _usageType == _UsageType.customer ? 'customer' : 'personal';
    final purposeValue = _selectedReason?.key;
    final amountValue = _usageType == _UsageType.customer
        ? _selectedGate?.price.toInt()
        : null;
    final attendantName = _usageType == _UsageType.personal ? _selectedAttendant?.name : null;
    final attendantId = _usageType == _UsageType.personal ? _selectedAttendant?.id : null;
    final doorValue = _usageType == _UsageType.customer
        ? _selectedGate?.gender ?? 'male'
        : _selectedGate?.deviceId ?? 'unknown';

    Log.info('🔓 Unlock - use: $useValue, door: $doorValue, purpose: $purposeValue, attendant: $attendantName');

    ref.read(doorLockActionProvider.notifier).unlock(
          facilityId: _facilityId,
          summary: _summary(context),
          authCode: _authCodeController.text,
          door: doorValue,
          use: useValue,
          amount: amountValue,
          purpose: purposeValue,
          attendant: attendantName,
          attendantId: attendantId,
        );
  }

  void _onLock() {
    ref.read(doorLockActionProvider.notifier).lock(facilityId: _facilityId);
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
      }
    });

    final statusAsync = ref.watch(doorStatusProvider(_facilityId));
    final actionState = ref.watch(doorLockActionProvider);

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: MenuItemAppBar(
        itemKey: MenuItemKey.doorLock,
        fallbackTitle: context.locale.doorControl,
      ),
      body: statusAsync.when(
        data: (status) => _buildBody(context, status, actionState),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) =>
            Center(child: Text(error.localizedMessage(context))),
      ),
    );
  }

  Widget _buildDoorStatusCard(BuildContext context) {
    final dimensions = context.dimensions;
    final authCode = _authCodeController.text;
    final doorStatesAsync = authCode.isNotEmpty
        ? ref.watch(doorStatesProvider((_facilityId, authCode)))
        : const AsyncValue.loading();

    return doorStatesAsync.when(
      data: (doorStates) {
        DoorStatusModel? matchingStatus;
        if (_selectedGate != null && doorStates.isNotEmpty) {
          matchingStatus = doorStates.firstWhere(
            (state) => state.door == _selectedGate!.deviceId,
            orElse: () => doorStates.first,
          );
        }

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
  ) {
    final gatesAsync = ref.watch(facilityGatesProvider(_facilityId));
    final locale = Localizations.localeOf(context).languageCode;

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
          'Select door to open',
          style: context.textStyle.bodyMedium.copyWith(
            color: context.color.text.secondary,
          ),
        ),
        Gap(dimensions.spacing.s12),
        gatesAsync.when(
          data: (gates) => Wrap(
            spacing: dimensions.spacing.s16,
            runSpacing: dimensions.spacing.s16,
            alignment: gates.length == 1 ? WrapAlignment.center : WrapAlignment.start,
            children: [
              for (final gate in gates)
                SizedBox(
                  width: gates.length == 1
                      ? 200
                      : (MediaQuery.of(context).size.width - (2 * dimensions.padding.p16) - (2 * dimensions.spacing.s16)) / 3,
                  child: GestureDetector(
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
                                '${gate.price.toStringAsFixed(0)} ৳',
                                style: context.textStyle.labelSmall.copyWith(
                                  color: context.color.onPrimary,
                                  fontWeight: TextWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
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
          'Select person who use the gate',
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
    DoorLockEntity status,
    AsyncValue<DoorUnlockResult?> actionState,
  ) {
    final dimensions = context.dimensions;
    final isLoading = actionState.isLoading;
    final unlockResult = actionState.valueOrNull;

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
                  isOffline: status.cachedData,
                ),
                Gap(dimensions.spacing.s16),
                _buildDoorStatusCard(context),
                Gap(dimensions.spacing.s16),
                if (!status.isLocked && unlockResult != null) ...[
                  _UnlockSuccessBanner(result: unlockResult),
                  Gap(dimensions.spacing.s16),
                ],
                if (status.isLocked) ...[
                  _buildAuthCodeField(context, dimensions, isLoading || status.cachedData),
                  Gap(dimensions.spacing.s16),
                  _UsageTypeSelector(
                    selected: _usageType,
                    onSelect: (isLoading || status.cachedData) ? null : _onUsageTypeChanged,
                  ),
                  Gap(dimensions.spacing.s16),
                  _buildServiceSelector(context, dimensions, isLoading || status.cachedData),
                  Gap(dimensions.spacing.s16),
                  if (_usageType == _UsageType.personal) ...[
                    _buildAttendantSelector(context, dimensions, isLoading || status.cachedData),
                    Gap(dimensions.spacing.s16),
                    _ReasonSelector(
                      selected: _selectedReason,
                      onSelect: (isLoading || status.cachedData)
                          ? null
                          : (reason) => setState(() => _selectedReason = reason),
                    ),
                  ],
                ],
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
              canUnlock: status.isLocked && _isReadyToUnlock && !isLoading && !status.cachedData,
              canLock: !status.isLocked && !isLoading,
              isUnlockLoading: isLoading && status.isLocked,
              isLockLoading: isLoading && !status.isLocked,
              isOffline: status.cachedData,
              onUnlock: _onUnlock,
              onLock: _onLock,
            ),
          ),
        ),
      ],
    );
  }
}
