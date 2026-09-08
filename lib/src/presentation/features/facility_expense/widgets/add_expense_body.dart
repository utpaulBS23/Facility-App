part of '../view/add_facility_expense_page.dart';

class _AddExpenseBody extends StatelessWidget {
  const _AddExpenseBody({
    required this.formKey,
    required this.amountController,
    required this.commentsController,
    required this.categoriesAsync,
    required this.paymentMethodsAsync,
    required this.category,
    required this.categoryError,
    required this.onSelectCategory,
    required this.facilityName,
    required this.facilities,
    required this.facilityEnabled,
    required this.facilityError,
    required this.onPickFacility,
    required this.expenseDate,
    required this.dateEnabled,
    required this.onPickDate,
    required this.amountEnabled,
    required this.paidBy,
    required this.paidByError,
    required this.onSelectPaidBy,
    required this.isSubmitting,
    required this.onCancel,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController amountController;
  final TextEditingController commentsController;
  final AsyncValue<List<MasterDataItemEntity>> categoriesAsync;
  final AsyncValue<List<MasterDataItemEntity>> paymentMethodsAsync;
  final MasterDataItemEntity? category;
  final bool categoryError;
  final ValueChanged<MasterDataItemEntity> onSelectCategory;
  final String? facilityName;
  final List<AccessibleFacilityEntity> facilities;
  final bool facilityEnabled;
  final bool facilityError;
  final VoidCallback onPickFacility;
  final DateTime expenseDate;
  final bool dateEnabled;
  final VoidCallback onPickDate;
  final bool amountEnabled;
  final MasterDataItemEntity? paidBy;
  final bool paidByError;
  final ValueChanged<MasterDataItemEntity> onSelectPaidBy;
  final bool isSubmitting;
  final VoidCallback onCancel;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

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
          categoriesAsync.when(
            loading: () => const LinearProgressIndicator(),
            error: (_, _) => BodySmallText(
              context.locale.selectExpenseCategory,
              color: context.color.error,
            ),
            data: (categories) => _MasterDataOptionSelector(
              options: categories,
              selected: category,
              hasError: categoryError,
              onChanged: onSelectCategory,
            ),
          ),
          Gap(spacing.s16),
          LabelLargeText(context.locale.selectFacility),
          Gap(spacing.s8),
          _DropdownField(
            value: facilityName,
            hint: context.locale.selectFacility,
            hasError: facilityError,
            onTap: facilityEnabled && facilities.length > 1
                ? onPickFacility
                : null,
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
            enabled: amountEnabled,
          ),
          Gap(spacing.s16),
          LabelLargeText(context.locale.paidBy),
          Gap(spacing.s8),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: amountController,
            builder: (context, amountValue, _) {
              final paidByEnabled =
                  (double.tryParse(amountValue.text.trim()) ?? 0) > 0;

              return paymentMethodsAsync.when(
                loading: () => const LinearProgressIndicator(),
                error: (_, _) => BodySmallText(
                  context.locale.paidBy,
                  color: context.color.error,
                ),
                data: (methods) => _MasterDataOptionSelector(
                  options: methods,
                  selected: paidBy,
                  hasError: paidByError,
                  enabled: paidByEnabled,
                  onChanged: onSelectPaidBy,
                ),
              );
            },
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
            canSubmit: paidBy != null,
            onCancel: onCancel,
            onSubmit: onSubmit,
          ),
          Gap(spacing.s16),
        ],
      ),
    );
  }
}
