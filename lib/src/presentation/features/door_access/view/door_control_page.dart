import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../core/extensions/failure_localization.dart';
import '../../../../domain/entities/door_lock_entity.dart';
import '../../../../domain/entities/facility_entity.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../core/widgets/text/typography.dart';
import '../riverpod/door_lock_action_provider.dart';
import '../riverpod/door_status_provider.dart';

part '../widgets/door_action_buttons.dart';
part '../widgets/door_status_card.dart';
part '../widgets/primary_device_card.dart';
part '../widgets/reason_selector.dart';
part '../widgets/service_type_selector.dart';
part '../widgets/unlock_success_banner.dart';
part '../widgets/usage_type_selector.dart';

enum _UsageType { personal, customer }

enum _ServiceType {
  urine(price: 5),
  toilet(price: 10),
  shower(price: 20);

  const _ServiceType({required this.price});

  final int price;

  String label(BuildContext context) => switch (this) {
    _ServiceType.urine => context.locale.urine,
    _ServiceType.toilet => context.locale.toilet,
    _ServiceType.shower => context.locale.shower,
  };
}

enum _Reason {
  clean,
  toilet,
  repair,
  inspect;

  String label(BuildContext context) => switch (this) {
    _Reason.clean => context.locale.reasonClean,
    _Reason.toilet => context.locale.reasonToilet,
    _Reason.repair => context.locale.reasonRepair,
    _Reason.inspect => context.locale.reasonInspect,
  };

  String subtitle(BuildContext context) => switch (this) {
    _Reason.clean => context.locale.washroomCleaning,
    _Reason.toilet => context.locale.personalUse,
    _Reason.repair => context.locale.maintenanceWork,
    _Reason.inspect => context.locale.facilityCheck,
  };
}

class DoorControlPage extends ConsumerStatefulWidget {
  const DoorControlPage({super.key, required this.facility});

  final FacilityEntity facility;

  @override
  ConsumerState<DoorControlPage> createState() => _DoorControlPageState();
}

class _DoorControlPageState extends ConsumerState<DoorControlPage> {
  _UsageType _usageType = _UsageType.customer;
  _ServiceType? _serviceType = _ServiceType.urine;
  _Reason? _reason;

  String get _facilityId => widget.facility.id.toString();

  bool get _isReadyToUnlock => switch (_usageType) {
    _UsageType.customer => _serviceType != null,
    _UsageType.personal => _reason != null,
  };

  String _summary(BuildContext context) => switch (_usageType) {
    _UsageType.customer =>
      '${context.locale.customerUse} '
          '(${_serviceType!.label(context)} — ৳${_serviceType!.price})',
    _UsageType.personal =>
      '${context.locale.personalUse} (${_reason!.label(context)})',
  };

  void _onUsageTypeChanged(_UsageType type) {
    setState(() {
      _usageType = type;
      _serviceType = type == _UsageType.customer ? _ServiceType.urine : null;
      _reason = null;
    });
  }

  void _onUnlock() {
    ref
        .read(doorLockActionProvider.notifier)
        .unlock(facilityId: _facilityId, summary: _summary(context));
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
      appBar: AppBar(
        leading: const AppBackButton(),
        leadingWidth: AppBackButton.width,
        title: Headline2xlTinyText(context.locale.doorControl),
        centerTitle: true,
        backgroundColor: context.color.onPrimary,
        surfaceTintColor: Colors.transparent,
      ),
      body: statusAsync.when(
        data: (status) => _buildBody(context, status, actionState),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) =>
            Center(child: Text(error.localizedMessage(context))),
      ),
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
                _DoorStatusCard(isLocked: status.isLocked),
                Gap(dimensions.spacing.s16),
                if (!status.isLocked && unlockResult != null) ...[
                  _UnlockSuccessBanner(result: unlockResult),
                  Gap(dimensions.spacing.s16),
                ],
                if (status.isLocked) ...[
                  _UsageTypeSelector(
                    selected: _usageType,
                    onSelect: isLoading ? null : _onUsageTypeChanged,
                  ),
                  Gap(dimensions.spacing.s16),
                  if (_usageType == _UsageType.customer)
                    _ServiceTypeSelector(
                      selected: _serviceType,
                      onSelect: isLoading
                          ? null
                          : (type) => setState(() => _serviceType = type),
                    )
                  else
                    _ReasonSelector(
                      selected: _reason,
                      onSelect: isLoading
                          ? null
                          : (reason) => setState(() => _reason = reason),
                    ),
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
              canUnlock: status.isLocked && _isReadyToUnlock && !isLoading,
              canLock: !status.isLocked && !isLoading,
              isUnlockLoading: isLoading && status.isLocked,
              isLockLoading: isLoading && !status.isLocked,
              onUnlock: _onUnlock,
              onLock: _onLock,
            ),
          ),
        ),
      ],
    );
  }
}
