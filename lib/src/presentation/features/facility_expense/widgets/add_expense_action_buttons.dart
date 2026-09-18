part of '../view/add_facility_expense_page.dart';

class _AddExpenseActionButtons extends ConsumerWidget {
  const _AddExpenseActionButtons({
    required this.isSubmitting,
    required this.onCancel,
    required this.onSubmit,
  });

  final bool isSubmitting;
  final VoidCallback onCancel;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = context.dimensions.spacing;
    final canSubmit = ref.watch(selectedExpensePaidByProvider) != null;

    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: onCancel,
            child: Text(context.locale.cancel),
          ),
        ),
        Gap(spacing.s12),
        Expanded(
          child: PermissionGate(
            permissions: const [UserPermission.facilityExpenseCreate],
            child: FilledButton(
              onPressed: isSubmitting || !canSubmit ? null : onSubmit,
              child: isSubmitting
                  ? SizedBox(
                      width: spacing.s20,
                      height: spacing.s20,
                      child: CircularProgressIndicator(
                        strokeWidth: spacing.s2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          context.color.onPrimary,
                        ),
                      ),
                    )
                  : Text(context.locale.submit),
            ),
          ),
        ),
      ],
    );
  }
}
