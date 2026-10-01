import '../../../core/utils/localized_text.dart';
import 'leave_type.dart';

class LeavePolicyEntity {
  const LeavePolicyEntity({
    required this.id,
    required this.name,
    required this.leaveType,
    required this.defaultDaysPerYear,
    required this.requiresApproval,
    required this.canCarryForward,
    this.nameBn,
  });

  final int id;
  final String name;
  final String? nameBn;
  final LeaveType leaveType;
  final double defaultDaysPerYear;
  final bool requiresApproval;
  final bool canCarryForward;

  String localizedName(String languageCode) =>
      localizedText(languageCode, name, nameBn);
}
