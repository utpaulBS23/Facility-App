import 'package:flutter/material.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/facility_tracking_entity.dart';
import '../../../core/theme/theme.dart';

extension FacilityPinStatusStyle on FacilityPinStatus {
  Color color(BuildContext context) => switch (this) {
    FacilityPinStatus.active => context.color.primary,
    FacilityPinStatus.maintenance => context.color.warning,
    FacilityPinStatus.inactive => context.color.text.muted,
  };

  String label(BuildContext context) => switch (this) {
    FacilityPinStatus.active => context.locale.active,
    FacilityPinStatus.maintenance => context.locale.facilityStatusMaintenance,
    FacilityPinStatus.inactive => context.locale.inactive,
  };
}

extension StaffPinStatusStyle on StaffPinStatus {
  Color color(BuildContext context) => switch (this) {
    StaffPinStatus.working => context.color.success,
    StaffPinStatus.free => context.color.warning,
    StaffPinStatus.contractEnded => context.color.text.muted,
  };

  String label(BuildContext context) => switch (this) {
    StaffPinStatus.working => context.locale.attendantWorkingNow,
    StaffPinStatus.free => context.locale.attendantFreeOffShift,
    StaffPinStatus.contractEnded => context.locale.attendantContractEnded,
  };
}
