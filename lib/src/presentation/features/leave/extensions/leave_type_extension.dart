import 'package:flutter/material.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/leave/leave_type.dart';

extension LeaveTypeLocalization on LeaveType {
  String localizedName(BuildContext context) {
    return switch (this) {
      LeaveType.sickLeave => context.locale.sickLeave,
      LeaveType.casualLeave => context.locale.casualLeave,
      LeaveType.maternityLeave => context.locale.maternityLeave,
      LeaveType.annualLeave => context.locale.annualLeave,
      LeaveType.unpaidLeave => context.locale.unpaidLeave,
      LeaveType.other => context.locale.other,
    };
  }
}
