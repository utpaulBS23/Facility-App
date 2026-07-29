part of '../view/shift_tab.dart';

class _ShiftDetailsBody extends StatelessWidget {
  const _ShiftDetailsBody({required this.entity});

  final ShiftEntity entity;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return SingleChildScrollView(
      padding: EdgeInsets.all(spacing.s16),
      child: Column(
        children: [
          _ShiftDetailContractCard(entity: entity),
          Gap(spacing.s8),
          _ShiftDetailSupervisorCard(entity: entity),
          if (entity.checkInTime != null) ...[
            Gap(spacing.s8),
            PermissionGate(
              permissions: [UserPermission.attendanceCheckIn],
              child: _ShiftDetailCheckInCard(entity: entity),
            ),
          ],
          if (entity.notes != null) ...[
            Gap(spacing.s8),
            _ShiftDetailNotesCard(notes: entity.notes!),
          ],
        ],
      ),
    );
  }
}
