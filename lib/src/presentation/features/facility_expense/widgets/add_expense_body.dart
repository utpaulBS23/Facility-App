part of '../view/add_facility_expense_page.dart';

class _AddExpenseBody extends ConsumerWidget {
  const _AddExpenseBody({
    required this.formKey,
    required this.amountController,
    required this.commentsController,
    required this.categoryError,
    required this.onCategorySelected,
    required this.facilityError,
    required this.onFacilitySelected,
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
  final bool facilityError;
  final VoidCallback onFacilitySelected;
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
    final facilityEnabled = ref.watch(selectedExpenseCategoryProvider) != null;
    final dateEnabled = ref.watch(selectedExpenseFacilityProvider) != null;

    return Form(
      key: formKey,
      child: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: spacing.s16,
          vertical: spacing.s20,
        ),
        children: [
          LabelLargeText(context.locale.selectTypeOfExpense),
          Gap(spacing.s8),
          _CategorySection(
            hasError: categoryError,
            onSelected: onCategorySelected,
          ),
          Gap(spacing.s16),
          LabelLargeText(context.locale.selectFacility),
          Gap(spacing.s8),
          _FacilitySection(
            enabled: facilityEnabled,
            hasError: facilityError,
            onSelected: onFacilitySelected,
          ),
          Gap(spacing.s16),
          LabelLargeText(context.locale.expenseDate),
          Gap(spacing.s8),
          _DropdownField(
            value: DateFormatter.shortDate(expenseDate),
            hint: context.locale.expenseDate,
            onTap: dateEnabled ? onPickDate : null,
          ),
          Gap(spacing.s16),
          AppTextField.text(
            controller: amountController,
            label: context.locale.amountBdt,
            hint: context.locale.enterAmount,
            enabled: dateEnabled,
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
          AppTextField.description(
            controller: commentsController,
            label: '${context.locale.comments} (${context.locale.optional})',
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
