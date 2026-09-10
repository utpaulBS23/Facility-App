part of '../view/add_additional_income_page.dart';

class _AddIncomeBody extends ConsumerWidget {
  const _AddIncomeBody({
    required this.formKey,
    required this.amountController,
    required this.descriptionController,
    required this.unitsSoldController,
    required this.incomeTypeError,
    required this.onIncomeTypeSelected,
    required this.facilityError,
    required this.onFacilitySelected,
    required this.amountError,
    required this.onAmountChanged,
    required this.productError,
    required this.onProductSelected,
    required this.unitsSoldError,
    required this.onUnitsSoldChanged,
    required this.entryDate,
    required this.onPickEntryDate,
    required this.isSubmitting,
    required this.onCancel,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController amountController;
  final TextEditingController descriptionController;
  final TextEditingController unitsSoldController;
  final bool incomeTypeError;
  final VoidCallback onIncomeTypeSelected;
  final bool facilityError;
  final VoidCallback onFacilitySelected;
  final bool amountError;
  final VoidCallback onAmountChanged;
  final bool productError;
  final VoidCallback onProductSelected;
  final bool unitsSoldError;
  final VoidCallback onUnitsSoldChanged;
  final DateTime entryDate;
  final VoidCallback onPickEntryDate;
  final bool isSubmitting;
  final VoidCallback onCancel;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = context.dimensions.spacing;
    final incomeType = ref.watch(selectedIncomeTypeProvider);
    final facilityEnabled = incomeType != null;
    final isProductSell = incomeType?.value == productSellIncomeTypeValue;
    final productSelected = ref.watch(selectedProductProvider) != null;

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
          if (isProductSell) ...[
            Gap(spacing.s16),
            LabelLargeText(context.locale.selectProduct),
            Gap(spacing.s8),
            _ProductDropdownSection(
              enabled: ref.watch(selectedIncomeFacilityProvider) != null,
              hasError: productError,
              onSelected: onProductSelected,
            ),
            Gap(spacing.s16),
            LabelLargeText(context.locale.entryDate),
            Gap(spacing.s8),
            _DropdownField(
              value: DateFormatter.shortDate(entryDate),
              hint: context.locale.entryDate,
              onTap: onPickEntryDate,
            ),
            Gap(spacing.s16),
            AppTextField.text(
              controller: unitsSoldController,
              label: context.locale.unitsSold,
              hint: context.locale.enterUnitsSold,
              keyboardType: TextInputType.number,
              enabled: productSelected,
              errorText: unitsSoldError
                  ? context.locale.unitsSoldExceedsStock
                  : null,
              onChanged: (_) => onUnitsSoldChanged(),
            ),
            if (ref.watch(selectedProductProvider) case final product?) ...[
              Gap(spacing.s4),
              BodySmallText(
                '${context.locale.availableStock}: ${product.stockQuantity}',
                color: context.color.text.secondary,
              ),
            ],
          ],
          Gap(spacing.s16),
          AppTextField.text(
            controller: amountController,
            label: isProductSell
                ? context.locale.unitPriceBdt
                : context.locale.amountBdt,
            hint: context.locale.enterAmount,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            enabled: !isProductSell || productSelected,
            errorText: amountError ? context.locale.fieldRequired : null,
            onChanged: (_) => onAmountChanged(),
          ),
          if (!isProductSell) ...[
            Gap(spacing.s16),
            AppTextField.description(
              controller: descriptionController,
              label: '${context.locale.comments} (${context.locale.optional})',
              hint: context.locale.commentsHint,
            ),
            Gap(spacing.s16),
            const _ProofPhotoPickerCard(),
          ],
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
