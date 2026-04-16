part of '../view/shift_page.dart';

class _ShiftDetailsBody extends StatelessWidget {
  const _ShiftDetailsBody({required this.data});

  final ShiftCardData data;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return SingleChildScrollView(
      padding: EdgeInsets.all(spacing.s16),
      child: Column(
        children: [
          _ShiftDetailContractCard(data: data),
          Gap(spacing.s8),
          _ShiftDetailSupervisorCard(data: data),
          if (data.shiftNotes != null) ...[
            Gap(spacing.s8),
            _ShiftDetailNotesCard(notes: data.shiftNotes!),
          ],
        ],
      ),
    );
  }
}
