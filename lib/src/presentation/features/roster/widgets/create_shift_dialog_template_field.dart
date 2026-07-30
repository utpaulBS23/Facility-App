part of '../view/roster_shifts_page.dart';

class _ShiftTemplateField extends StatelessWidget {
  const _ShiftTemplateField({
    required this.templatesState,
    required this.selectedTemplateId,
    required this.onChanged,
  });

  final AsyncValue<List<ShiftTemplateEntity>> templatesState;
  final int? selectedTemplateId;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ShiftFieldLabel(context.locale.shiftTemplate),
        Gap(context.dimensions.spacing.s8),
        templatesState.when(
          loading: () => const LinearProgressIndicator(),
          error: (err, _) => Text(
            err.localizedMessage(context),
            style: context.textStyle.bodySmall.copyWith(
              color: context.color.error,
            ),
          ),
          data: (templates) => AppDropdownButtonFormField<int>(
            initialValue: selectedTemplateId,
            hint: Text(context.locale.selectShiftTemplate),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  context.dimensions.radius.r6,
                ),
              ),
            ),
            items: [
              for (final template in templates)
                DropdownMenuItem(
                  value: template.id,
                  child: Text(
                    '${template.name} (${template.startTime}–${template.endTime})',
                  ),
                ),
            ],
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
