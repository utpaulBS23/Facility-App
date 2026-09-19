part of '../view/add_additional_income_page.dart';

class _AddIncomeBody extends ConsumerWidget {
  const _AddIncomeBody({
    required this.formKey,
    required this.incomeEntryType,
    required this.onIncomeEntryTypeChanged,
    required this.amountController,
    required this.descriptionController,
    required this.productLegs,
    required this.productLegsShowErrors,
    required this.onProductLegChanged,
    required this.onAddProductLeg,
    required this.onRemoveProductLeg,
    required this.incomeTypeError,
    required this.onIncomeTypeSelected,
    required this.facilityError,
    required this.onFacilitySelected,
    required this.amountError,
    required this.onAmountChanged,
    required this.entryDate,
    required this.onPickEntryDate,
    required this.isSubmitting,
    required this.onCancel,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final IncomeEntryType incomeEntryType;
  final ValueChanged<IncomeEntryType> onIncomeEntryTypeChanged;
  final TextEditingController amountController;
  final TextEditingController descriptionController;
  final List<_ProductLegDraft> productLegs;
  final bool productLegsShowErrors;
  final VoidCallback onProductLegChanged;
  final VoidCallback onAddProductLeg;
  final ValueChanged<_ProductLegDraft> onRemoveProductLeg;
  final bool incomeTypeError;
  final VoidCallback onIncomeTypeSelected;
  final bool facilityError;
  final VoidCallback onFacilitySelected;
  final bool amountError;
  final VoidCallback onAmountChanged;
  final DateTime entryDate;
  final VoidCallback onPickEntryDate;
  final bool isSubmitting;
  final VoidCallback onCancel;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = context.dimensions.spacing;
    final isProductSell = incomeEntryType == IncomeEntryType.productSell;
    final facilitySelected = ref.watch(selectedIncomeFacilityProvider) != null;
    final incomeTypeSelected = ref.watch(selectedIncomeTypeProvider) != null;
    final amountEnabled = incomeTypeSelected;
    final products =
        ref.watch(facilityProductOptionsProvider).valueOrNull ??
        const <FacilityProductEntity>[];

    return Form(
      key: formKey,
      child: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: spacing.s16,
          vertical: spacing.s20,
        ),
        children: [
          _IncomeEntryTypeSwitch(
            selectedType: incomeEntryType,
            onTypeChanged: onIncomeEntryTypeChanged,
          ),
          Gap(spacing.s16),
          LabelLargeText(context.locale.selectFacility),
          Gap(spacing.s8),
          _IncomeFacilitySection(
            enabled: true,
            hasError: facilityError,
            onSelected: onFacilitySelected,
          ),
          if (!isProductSell) ...[
            Gap(spacing.s16),
            LabelLargeText(context.locale.selectIncomeType),
            Gap(spacing.s8),
            _IncomeTypeSection(
              enabled: facilitySelected,
              hasError: incomeTypeError,
              onSelected: onIncomeTypeSelected,
            ),
            Gap(spacing.s16),
            AppTextField.description(
              controller: descriptionController,
              label: '${context.locale.incomeDescription} (${context.locale.optional})',
              hint: context.locale.incomeDescriptionHint,
              enabled: incomeTypeSelected,
            ),
          ],
          if (isProductSell) ...[
            Gap(spacing.s16),
            LabelLargeText(context.locale.entryDate),
            Gap(spacing.s8),
            _DropdownField(
              value: DateFormatter.shortDate(entryDate),
              hint: context.locale.entryDate,
              onTap: facilitySelected ? onPickEntryDate : null,
            ),
            Gap(spacing.s16),
            LabelLargeText(context.locale.selectProduct),
            Gap(spacing.s8),
            for (final leg in productLegs) ...[
              _ProductLegRow(
                leg: leg,
                products: products,
                showErrors: productLegsShowErrors,
                onChanged: onProductLegChanged,
                onRemove: () => onRemoveProductLeg(leg),
                showRemove: productLegs.length > 1,
              ),
              Gap(spacing.s8),
            ],
            TextButton.icon(
              onPressed: facilitySelected ? onAddProductLeg : null,
              icon: const Icon(Icons.add),
              label: Text(context.locale.addAnotherProduct),
              style: OutlinedButton.styleFrom(
                foregroundColor: context.color.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    context.dimensions.radius.r12,
                  ),
                ),
              ),
            ),
          ] else ...[
            Gap(spacing.s16),
            AppTextField.text(
              controller: amountController,
              label: context.locale.amountBdt,
              hint: context.locale.enterAmount,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              enabled: amountEnabled,
              errorText: amountError ? context.locale.fieldRequired : null,
              onChanged: (_) => onAmountChanged(),
            ),
            Gap(spacing.s16),
            const _ProofPhotoPickerCard(),
          ],
          Gap(spacing.s24),
          _AddIncomeActionButtons(
            incomeEntryType: incomeEntryType,
            productLegsValid: productLegs.every((leg) => leg.isValid),
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
