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
          _InfoRow(
            icon: Icons.location_on_outlined,
            label: data.address,
          ),
        ],
      ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label, required this.dotColor});

  final String label;
  final Color dotColor;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: spacing.s10,
          height: spacing.s10,
          decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
        ),
        Gap(spacing.s4),
        Text(
          label,
          style: context.textStyle.bodySmall.copyWith(
            color: context.color.text.secondary,
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Row(
      children: [
        Icon(icon, size: 16, color: context.color.text.secondary),
        Gap(spacing.s4),
        Text(
          label,
          style: context.textStyle.bodySmall.copyWith(
            color: context.color.text.secondary,
          ),
        ),
      ],
    );
  }
}
