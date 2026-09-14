import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../core/extensions/failure_localization.dart';
import '../../../../domain/entities/additional_income/additional_income_payloads.dart';
import '../../../../domain/entities/login_entity.dart';
import '../../../../domain/entities/master_data_entity.dart';
import '../../../../domain/entities/facility_product/facility_product_entity.dart';
import '../../../../domain/entities/product_sale_entry/product_sale_entry_payloads.dart';
import '../../../core/application_state/session_provider/session_provider.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/detail_app_bar.dart';
import '../../../core/widgets/permission_gate.dart';
import '../../../core/widgets/text/typography.dart';
import '../riverpod/submit_income_provider/facility_product_options_provider.dart';
import '../riverpod/submit_income_provider/income_type_options_provider.dart';
import '../riverpod/submit_income_provider/selected_income_facility_provider.dart';
import '../riverpod/submit_income_provider/selected_income_type_provider.dart';
import '../riverpod/submit_income_provider/selected_product_provider.dart';
import '../riverpod/submit_income_provider/submit_income_provider.dart';

part '../widgets/add_income_action_buttons.dart';
part '../widgets/add_income_body.dart';
part '../widgets/income_dropdown_field.dart';
part '../widgets/income_entry_type_switch.dart';
part '../widgets/income_facility_list_sheet.dart';
part '../widgets/income_facility_section.dart';
part '../widgets/income_master_data_selector.dart';
part '../widgets/income_type_section.dart';
part '../widgets/product_dropdown_field.dart';
part '../widgets/proof_photo_picker_card.dart';

class AddAdditionalIncomePage extends ConsumerStatefulWidget {
  const AddAdditionalIncomePage({super.key});

  @override
  ConsumerState<AddAdditionalIncomePage> createState() =>
      _AddAdditionalIncomePageState();
}

class _AddAdditionalIncomePageState
    extends ConsumerState<AddAdditionalIncomePage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _unitsSoldController = TextEditingController();

  IncomeEntryType _incomeEntryType = IncomeEntryType.rentAndOthers;
  bool _incomeTypeError = false;
  bool _facilityError = false;
  bool _amountError = false;
  bool _productError = false;
  bool _unitsSoldError = false;
  DateTime _entryDate = DateTime.now();

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _unitsSoldController.dispose();
    super.dispose();
  }

  void _onIncomeEntryTypeChanged(IncomeEntryType type) {
    setState(() {
      _incomeEntryType = type;
      _incomeTypeError = false;
      _productError = false;
      _unitsSoldError = false;
      _amountError = false;
      _amountController.clear();
      _descriptionController.clear();
      _unitsSoldController.clear();
      ref.read(selectedIncomeTypeProvider.notifier).select(null);
      ref.read(selectedProductProvider.notifier).select(null);
    });
  }

  Future<void> _onPickEntryDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _entryDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _entryDate = picked);
  }

  void _onSubmitAdditionalIncome() {
    final incomeType = ref.read(selectedIncomeTypeProvider);
    final facilityId = ref.read(selectedIncomeFacilityProvider);
    final amount = double.tryParse(_amountController.text.trim()) ?? 0;

    final incomeTypeOk = incomeType != null;
    final facilityOk = facilityId != null;
    final amountOk = amount > 0;

    setState(() {
      _incomeTypeError = !incomeTypeOk;
      _facilityError = !facilityOk;
      _amountError = !amountOk;
    });

    if (!_formKey.currentState!.validate() ||
        !incomeTypeOk ||
        !facilityOk ||
        !amountOk) {
      return;
    }

    final description = _descriptionController.text.trim();

    ref
        .read(submitIncomeProvider.notifier)
        .submit(
          incomeRequest: CreateAdditionalIncomeRequestEntity(
            facilityId: facilityId,
            incomeType: incomeType.value,
            description: description.isEmpty ? null : description,
            amount: amount,
          ),
        );
  }

  void _onSubmitProductSale() {
    final product = ref.read(selectedProductProvider);
    final facilityId = ref.read(selectedIncomeFacilityProvider);
    final unitsSold = int.tryParse(_unitsSoldController.text.trim()) ?? 0;
    final unitPrice = double.tryParse(_amountController.text.trim()) ?? 0;

    final productOk = product != null;
    final facilityOk = facilityId != null;
    final unitsSoldOk =
        unitsSold > 0 && (product == null || unitsSold <= product.stockQuantity);
    final unitPriceOk = unitPrice > 0;

    setState(() {
      _productError = !productOk;
      _facilityError = !facilityOk;
      _unitsSoldError = !unitsSoldOk;
      _amountError = !unitPriceOk;
    });

    if (!_formKey.currentState!.validate() ||
        !productOk ||
        !facilityOk ||
        !unitsSoldOk ||
        !unitPriceOk) {
      return;
    }

    ref
        .read(submitIncomeProvider.notifier)
        .submit(
          productSaleRequest: CreateProductSaleEntryRequestEntity(
            facilityId: facilityId,
            entryDate: _entryDate,
            items: [
              CreateProductSaleEntryItemEntity(
                productId: product.productId,
                unitsSold: unitsSold,
                unitPrice: unitPrice,
              ),
            ],
          ),
        );
  }

  void _onSubmit() {
    switch (_incomeEntryType) {
      case IncomeEntryType.rentAndOthers:
        _onSubmitAdditionalIncome();
      case IncomeEntryType.productSell:
        _onSubmitProductSale();
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(submitIncomeProvider, (previous, next) {
      if (previous?.isLoading == true && next.hasValue && next.value == true) {
        AppSnackBar.showSuccess(context, context.locale.incomeSubmittedSuccess);
        context.pop();
      } else if (next.hasError) {
        AppSnackBar.showError(context, next.error!.localizedMessage(context));
      }
    });

    final isSubmitting = ref.watch(submitIncomeProvider).isLoading;

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: DetailAppBar(title: context.locale.addIncome),
      body: _AddIncomeBody(
        formKey: _formKey,
        incomeEntryType: _incomeEntryType,
        onIncomeEntryTypeChanged: _onIncomeEntryTypeChanged,
        amountController: _amountController,
        descriptionController: _descriptionController,
        unitsSoldController: _unitsSoldController,
        incomeTypeError: _incomeTypeError,
        onIncomeTypeSelected: () => setState(() => _incomeTypeError = false),
        facilityError: _facilityError,
        onFacilitySelected: () => setState(() => _facilityError = false),
        amountError: _amountError,
        onAmountChanged: () {
          if (_amountError) setState(() => _amountError = false);
        },
        productError: _productError,
        onProductSelected: () {
          final product = ref.read(selectedProductProvider);
          setState(() {
            _productError = false;
            if (product != null) {
              _amountController.text = product.price.toString();
            }
          });
        },
        unitsSoldError: _unitsSoldError,
        onUnitsSoldChanged: () {
          if (_unitsSoldError) setState(() => _unitsSoldError = false);
        },
        entryDate: _entryDate,
        onPickEntryDate: _onPickEntryDate,
        isSubmitting: isSubmitting,
        onCancel: () => context.pop(),
        onSubmit: _onSubmit,
      ),
    );
  }
}
