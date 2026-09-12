part of '../view/add_facility_expense_page.dart';

class _AddExpenseBody extends ConsumerWidget {
  const _AddExpenseBody({
    required this.formKey,
    required this.amountController,
    required this.commentsController,
    required this.categoryError,
    required this.onCategorySelected,
    required this.onCategoryTap,
    required this.facilityError,
    required this.onFacilitySelected,
    required this.onFacilityTap,
    required this.canPickFacility,
    required this.expenseDate,
    required this.onPickDate,
    required this.amountError,
    required this.onAmountChanged,
    required this.paidByError,
    required this.onPaidBySelected,
    required this.isSubmitting,
    required this.onCancel,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController amountController;
  final TextEditingController commentsController;
  final bool categoryError;
  final VoidCallback onCategorySelected;
  final VoidCallback onCategoryTap;
  final bool facilityError;
  final VoidCallback onFacilitySelected;
  final VoidCallback onFacilityTap;
  final bool canPickFacility;
  final DateTime expenseDate;
  final VoidCallback onPickDate;
  final bool amountError;
  final VoidCallback onAmountChanged;
  final bool paidByError;
  final VoidCallback onPaidBySelected;
  final bool isSubmitting;
  final VoidCallback onCancel;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final categorySelected = ref.watch(selectedExpenseCategoryProvider);
    final facilitySelected = ref.watch(selectedExpenseFacilityProvider);

    return Form(
      key: formKey,
      child: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: spacing.s16,
          vertical: spacing.s20,
        ),
        children: [
          LabelLargeText(context.locale.selectFacility),
          Gap(spacing.s8),
          Consumer(
            builder: (context, ref, _) {
              final facilities =
                  ref.watch(userSessionProvider)?.accessibleFacilities ??
                  const <AccessibleFacilityEntity>[];
              final facilityName = facilities
                  .firstWhere((f) => f.id == facilitySelected,
                      orElse: () =>
                          AccessibleFacilityEntity(id: 0, name: '', isPrimary: false))
                  .name;
              return GestureDetector(
                onTap: canPickFacility ? onFacilityTap : null,
                child: Container(
                  height: 52,
                  padding: EdgeInsets.symmetric(horizontal: spacing.s16),
                  decoration: BoxDecoration(
                    color: facilityError
                        ? context.color.error.withOpacity(0.1)
                        : context.color.onPrimary,
                    border: Border.all(
                      color: facilityError
                          ? context.color.error
                          : context.color.borderSubtle,
                    ),
                    borderRadius: BorderRadius.circular(radius.r6),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          facilityName.isNotEmpty
                              ? facilityName
                              : context.locale.selectFacility,
                          overflow: TextOverflow.ellipsis,
                          style: facilityName.isNotEmpty
                              ? context.textStyle.bodyMedium
                              : context.textStyle.bodyMedium.copyWith(
                                  color: context.color.text.secondary,
                                ),
                        ),
                      ),
                      if (canPickFacility)
                        Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: context.color.text.secondary,
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
          Gap(spacing.s16),
          LabelLargeText(context.locale.selectTypeOfExpense),
          Gap(spacing.s8),
          GestureDetector(
            onTap: onCategoryTap,
            child: Container(
              height: 52,
              padding: EdgeInsets.symmetric(horizontal: spacing.s16),
              decoration: BoxDecoration(
                color: categoryError
                    ? context.color.error.withOpacity(0.1)
                    : context.color.onPrimary,
                border: Border.all(
                  color: categoryError
                      ? context.color.error
                      : context.color.borderSubtle,
                ),
                borderRadius: BorderRadius.circular(radius.r6),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      categorySelected?.label ?? context.locale.selectTypeOfExpense,
                      overflow: TextOverflow.ellipsis,
                      style: categorySelected != null
                          ? context.textStyle.bodyMedium
                          : context.textStyle.bodyMedium.copyWith(
                              color: context.color.text.secondary,
                            ),
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: context.color.text.secondary,
                  ),
                ],
              ),
            ),
          ),
          Gap(spacing.s16),
          LabelLargeText(context.locale.expenseDate),
          Gap(spacing.s8),
          GestureDetector(
            onTap: onPickDate,
            child: Container(
              height: 52,
              padding: EdgeInsets.symmetric(horizontal: spacing.s16),
              decoration: BoxDecoration(
                color: context.color.onPrimary,
                border: Border.all(color: context.color.borderSubtle),
                borderRadius: BorderRadius.circular(radius.r6),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      DateFormatter.shortDate(expenseDate),
                      overflow: TextOverflow.ellipsis,
                      style: context.textStyle.bodyMedium,
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: context.color.text.secondary,
                  ),
                ],
              ),
            ),
          ),
          Gap(spacing.s16),
          LabelLargeText(context.locale.amountBdt),
          Gap(spacing.s8),
          AppTextField.text(
            controller: amountController,
            hint: context.locale.enterAmount,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            errorText: amountError ? context.locale.fieldRequired : null,
            onChanged: (_) => onAmountChanged(),
          ),
          Gap(spacing.s16),
          LabelLargeText(context.locale.paidBy),
          Gap(spacing.s8),
          _PaidBySection(
            amountController: amountController,
            hasError: paidByError,
            onSelected: onPaidBySelected,
          ),
          Gap(spacing.s16),
          LabelLargeText(
            '${context.locale.comments} (${context.locale.optional})',
          ),
          Gap(spacing.s8),
          AppTextField.description(
            controller: commentsController,
            hint: context.locale.commentsHint,
          ),
          Gap(spacing.s24),
          _AddExpenseActionButtons(
            isSubmitting: isSubmitting,
            onCancel: onCancel,
            onSubmit: onSubmit,
          ),
          Gap(spacing.s16),
        ],
      ),
    );
  }
}
