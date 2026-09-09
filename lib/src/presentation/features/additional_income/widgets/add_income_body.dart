part of '../view/add_additional_income_page.dart';

class _AddIncomeBody extends ConsumerWidget {
  const _AddIncomeBody({
    required this.formKey,
    required this.amountController,
    required this.descriptionController,
    required this.incomeTypeError,
    required this.onIncomeTypeSelected,
    required this.facilityError,
    required this.onFacilitySelected,
    required this.amountError,
    required this.onAmountChanged,
    required this.isSubmitting,
    required this.onCancel,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController amountController;
  final TextEditingController descriptionController;
  final bool incomeTypeError;
  final VoidCallback onIncomeTypeSelected;
  final bool facilityError;
  final VoidCallback onFacilitySelected;
  final bool amountError;
  final VoidCallback onAmountChanged;
  final bool isSubmitting;
  final VoidCallback onCancel;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = context.dimensions.spacing;
    // WHY always enabled: income-type master data isn't populated yet
    // (placeholder category key, see EXTRA_COLLECTION_GAPS.md), so gating
    // facility on it would block the form entirely. Re-enable the cascade
    // once the real income-type key/data is wired up.
    const facilityEnabled = true;

    return Form(
      key: formKey,
      child: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: spacing.s16,
          vertical: spacing.s20,
        ),
        children: [
          LabelLargeText(context.locale.selectIncomeType),
          Gap(spacing.s8),
          _IncomeTypeSection(
            hasError: incomeTypeError,
            onSelected: onIncomeTypeSelected,
          ),
          Gap(spacing.s16),
          LabelLargeText(context.locale.selectFacility),
          Gap(spacing.s8),
          _IncomeFacilitySection(
            enabled: facilityEnabled,
            hasError: facilityError,
            onSelected: onFacilitySelected,
          ),
          Gap(spacing.s16),
          AppTextField.text(
            controller: amountController,
            label: context.locale.amountBdt,
            hint: context.locale.enterAmount,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            errorText: amountError ? context.locale.fieldRequired : null,
            onChanged: (_) => onAmountChanged(),
          ),
          Gap(spacing.s16),
          AppTextField.description(
            controller: descriptionController,
            label: '${context.locale.comments} (${context.locale.optional})',
            hint: context.locale.commentsHint,
          ),
          Gap(spacing.s16),
          const _ProofPhotoPickerCard(),
          Gap(spacing.s24),
          _AddIncomeActionButtons(
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
