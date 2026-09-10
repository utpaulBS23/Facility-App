part of '../view/add_additional_income_page.dart';

class _AddIncomeActionButtons extends ConsumerWidget {
  const _AddIncomeActionButtons({
    required this.incomeEntryType,
    required this.isSubmitting,
    required this.onCancel,
    required this.onSubmit,
  });

  final IncomeEntryType incomeEntryType;
  final bool isSubmitting;
  final VoidCallback onCancel;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = context.dimensions.spacing;
    final isProductSell = incomeEntryType == IncomeEntryType.productSell;
    final facilityOk = ref.watch(selectedIncomeFacilityProvider) != null;
    final productOk =
        !isProductSell || ref.watch(selectedProductProvider) != null;
    final canSubmit = facilityOk && productOk;
    final requiredPermission = isProductSell
        ? UserPermission.productSaleEntryCreate
        : UserPermission.additionalIncomeCreate;

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
            permissions: [requiredPermission],
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
