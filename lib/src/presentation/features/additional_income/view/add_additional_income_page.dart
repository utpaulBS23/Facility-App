import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../core/extensions/failure_localization.dart';
import '../../../../domain/entities/additional_income/additional_income_payloads.dart';
import '../../../../domain/entities/login_entity.dart';
import '../../../../domain/entities/master_data_entity.dart';
import '../../../core/application_state/session_provider/session_provider.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/detail_app_bar.dart';
import '../../../core/widgets/permission_gate.dart';
import '../../../core/widgets/text/typography.dart';
import '../riverpod/submit_income_provider/income_dropdowns_provider.dart';
import '../riverpod/submit_income_provider/selected_income_facility_provider.dart';
import '../riverpod/submit_income_provider/selected_income_type_provider.dart';
import '../riverpod/submit_income_provider/submit_additional_income_provider.dart';

part '../widgets/add_income_action_buttons.dart';
part '../widgets/add_income_body.dart';
part '../widgets/income_dropdown_field.dart';
part '../widgets/income_facility_list_sheet.dart';
part '../widgets/income_facility_section.dart';
part '../widgets/income_master_data_selector.dart';
part '../widgets/income_type_section.dart';
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

  bool _incomeTypeError = false;
  bool _facilityError = false;
  bool _amountError = false;

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _onSubmit() {
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
        .read(submitAdditionalIncomeProvider.notifier)
        .submit(
          CreateAdditionalIncomeRequestEntity(
            facilityId: facilityId,
            incomeType: incomeType.value,
            description: description.isEmpty ? null : description,
            amount: amount,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(submitAdditionalIncomeProvider, (previous, next) {
      if (previous?.isLoading == true && next.hasValue && next.value != null) {
        AppSnackBar.showSuccess(context, context.locale.incomeSubmittedSuccess);
        context.pop();
      } else if (next.hasError) {
        AppSnackBar.showError(context, next.error!.localizedMessage(context));
      }
    });

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: DetailAppBar(title: context.locale.addIncome),
      body: _AddIncomeBody(
        formKey: _formKey,
        amountController: _amountController,
        descriptionController: _descriptionController,
        incomeTypeError: _incomeTypeError,
        onIncomeTypeSelected: () => setState(() => _incomeTypeError = false),
        facilityError: _facilityError,
        onFacilitySelected: () => setState(() => _facilityError = false),
        amountError: _amountError,
        onAmountChanged: () {
          if (_amountError) setState(() => _amountError = false);
        },
        isSubmitting: ref.watch(submitAdditionalIncomeProvider).isLoading,
        onCancel: () => context.pop(),
        onSubmit: _onSubmit,
      ),
    );
  }
}
