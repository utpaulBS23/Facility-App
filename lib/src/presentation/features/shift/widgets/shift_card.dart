part of '../view/shift_page.dart';

enum ShiftStatus { inProgress, upcoming }

class ShiftCardData {
  const ShiftCardData({
    required this.facilityName,
    required this.supervisorName,
    required this.supervisorPhone,
    required this.address,
    required this.timeRange,
    required this.date,
    required this.shiftDate,
    required this.status,
    this.hoursWorked,
    this.shiftType,
    this.shiftNotes,
    // WHY: Supervisor view shows a separately assigned staff member distinct
    // from the shift's primary contact; null means no one assigned yet.
    this.assignedStaffName,
    this.assignedStaffPhone,
  });

  final String facilityName;
  final String supervisorName;
  final String supervisorPhone;
  final String address;
  final String timeRange;

  // WHY: Human-readable date label shown on the details page.
  final String date;

  // WHY: Exact date used to filter shift cards when the user picks a day.
  final DateTime shiftDate;
  final ShiftStatus status;
  final String? hoursWorked;
  final String? shiftType;
  final String? shiftNotes;
  final String? assignedStaffName;
  final String? assignedStaffPhone;
}

class _ShiftCard extends StatelessWidget {
  const _ShiftCard({required this.data, required this.onTap});

  final ShiftCardData data;
  final VoidCallback onTap;

  Color _dotColor(BuildContext context) => switch (data.status) {
    ShiftStatus.inProgress => context.color.success,
    ShiftStatus.upcoming => context.color.warning,
  };

  String _statusLabel(BuildContext context) => switch (data.status) {
    ShiftStatus.inProgress => context.locale.inProgress,
    ShiftStatus.upcoming => context.locale.upcoming,
  };

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.all(spacing.s16),
        decoration: BoxDecoration(
          color: context.color.onPrimary,
          border: Border.all(color: context.color.borderSubtle),
          borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status dot + label | Time range
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _StatusBadge(
                  label: _statusLabel(context),
                  dotColor: _dotColor(context),
                ),
                Text(
                  data.timeRange,
                  style: context.textStyle.labelLarge.copyWith(
                    color: context.color.text.primary,
                  ),
                ),
              ],
            ),
            Gap(spacing.s8),
            // Facility name
            Text(
              data.facilityName,
              style: context.textStyle.labelLarge.copyWith(
                color: context.color.text.primary,
              ),
            ),
            Gap(spacing.s6),
            // Supervisor row
            _InfoRow(
              icon: Icons.person_outline_rounded,
              label: data.supervisorName,
            ),
            Gap(spacing.s6),
            // Address row
            _InfoRow(icon: Icons.location_on_outlined, label: data.address),
          ],
        ),
      ),
    );
  }
}

class _SupervisorShiftCard extends StatelessWidget {
  const _SupervisorShiftCard({
    required this.data,
    required this.onAssignStaff,
    required this.onShiftTap,
  });

  final ShiftCardData data;
  final VoidCallback onAssignStaff;
  final VoidCallback onShiftTap;

  Color _dotColor(BuildContext context) => switch (data.status) {
    ShiftStatus.inProgress => context.color.success,
    ShiftStatus.upcoming => context.color.warning,
  };

  String _statusLabel(BuildContext context) => switch (data.status) {
    ShiftStatus.inProgress => context.locale.inProgress,
    ShiftStatus.upcoming => context.locale.upcoming,
  };

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return GestureDetector(
      onTap: onShiftTap,
      child: Container(
        padding: EdgeInsets.all(spacing.s16),
        decoration: BoxDecoration(
          color: context.color.onPrimary,
          border: Border.all(color: context.color.borderSubtle),
          borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _StatusBadge(
                  label: _statusLabel(context),
                  dotColor: _dotColor(context),
                ),
                Gap(spacing.s8),
                _StatusBadge(
                  label: context.locale.employeeShortest,
                  dotColor: context.color.warning,
                ),
              ],
            ),
            Gap(spacing.s8),
            Text(
              data.timeRange,
              style: context.textStyle.labelLarge.copyWith(
                color: context.color.text.primary,
              ),
            ),
            Gap(spacing.s8),
            Text(
              data.facilityName,
              style: context.textStyle.labelLarge.copyWith(
                color: context.color.text.primary,
              ),
            ),
            Gap(spacing.s6),
            _InfoRow(
              icon: Icons.person_outline_rounded,
              label: data.supervisorName,
            ),
            Gap(spacing.s6),
            _InfoRow(icon: Icons.location_on_outlined, label: data.address),
            Gap(spacing.s20),
            _AssignedSection(data: data, onAssignStaff: onAssignStaff),
          ],
        ),
      ),
    );
  }
}
