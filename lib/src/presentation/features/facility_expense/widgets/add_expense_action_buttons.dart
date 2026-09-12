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
    final radius = context.dimensions.radius;
    final canSubmit = ref.watch(selectedExpensePaidByProvider) != null;

    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: spacing.s56,
            child: OutlinedButton(
              onPressed: onCancel,
              style: OutlinedButton.styleFrom(
                foregroundColor: context.color.error,
                side: BorderSide(color: context.color.error),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radius.r12),
                ),
              ),
              child: Text(
                context.locale.cancel,
                style: context.textStyle.labelLarge.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
        Gap(spacing.s12),
        Expanded(
          child: PermissionGate(
            permissions: const [UserPermission.facilityExpenseCreate],
            child: SizedBox(
              height: spacing.s56,
              child: FilledButton(
                onPressed: isSubmitting || !canSubmit ? null : onSubmit,
                style: FilledButton.styleFrom(
                  backgroundColor: context.color.primary,
                  foregroundColor: context.color.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(radius.r12),
                  ),
                ),
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
                    : Text(
                        context.locale.submit,
                        style: context.textStyle.labelLarge.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
