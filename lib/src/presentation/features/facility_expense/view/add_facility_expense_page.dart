import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../core/extensions/failure_localization.dart';
import '../../../../domain/entities/facility_expense/facility_expense_payloads.dart';
import '../../../../domain/entities/login_entity.dart';
import '../../../../domain/entities/master_data_entity.dart';
import '../../../core/application_state/session_provider/session_provider.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/detail_app_bar.dart';
import '../../../core/widgets/permission_gate.dart';
import '../../../core/widgets/text/typography.dart';
import '../riverpod/submit_expense_provider/expense_dropdowns_provider.dart';
import '../riverpod/submit_expense_provider/selected_expense_category_provider.dart';
import '../riverpod/submit_expense_provider/selected_expense_facility_provider.dart';
import '../riverpod/submit_expense_provider/selected_expense_paid_by_provider.dart';
import '../riverpod/submit_expense_provider/submit_facility_expense_provider.dart';

part '../widgets/add_expense_action_buttons.dart';
part '../widgets/add_expense_body.dart';
part '../widgets/expense_category_section.dart';
part '../widgets/expense_dropdown_field.dart';
part '../widgets/expense_facility_list_sheet.dart';
part '../widgets/expense_facility_section.dart';
part '../widgets/expense_master_data_selector.dart';
part '../widgets/expense_paid_by_section.dart';

class AddFacilityExpensePage extends ConsumerStatefulWidget {
  const AddFacilityExpensePage({super.key});

  @override
  ConsumerState<AddFacilityExpensePage> createState() =>
      _AddFacilityExpensePageState();
}

class _AddFacilityExpensePageState
    extends ConsumerState<AddFacilityExpensePage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _commentsController = TextEditingController();

  bool _categoryError = false;
  bool _facilityError = false;
  DateTime _expenseDate = DateTime.now();
  bool _amountError = false;
  bool _paidByError = false;

  @override
  void dispose() {
    _amountController.dispose();
    _commentsController.dispose();
    super.dispose();
  }

  Future<void> _onPickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _expenseDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _expenseDate = picked);
  }

  void _onSubmit() {
    final category = ref.read(selectedExpenseCategoryProvider);
    final facilityId = ref.read(selectedExpenseFacilityProvider);
    final paidBy = ref.read(selectedExpensePaidByProvider);
    final amount = double.tryParse(_amountController.text.trim()) ?? 0;

    final categoryOk = category != null;
    final facilityOk = facilityId != null;
    final amountOk = amount > 0;
    final paidByOk = paidBy != null;

    setState(() {
      _categoryError = !categoryOk;
      _facilityError = !facilityOk;
      _amountError = !amountOk;
      _paidByError = !paidByOk;
    });

    if (!_formKey.currentState!.validate() ||
        !categoryOk ||
        !facilityOk ||
        !amountOk ||
        !paidByOk) {
      return;
    }

    final note = _commentsController.text.trim();

    ref
        .read(submitFacilityExpenseProvider.notifier)
        .submit(
          CreateFacilityExpenseRequestEntity(
            facilityId: facilityId,
            category: category.value,
            amount: amount,
            expenseDate: _expenseDate,
            paidBy: paidBy.value,
            note: note.isEmpty ? null : note,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(submitFacilityExpenseProvider, (previous, next) {
      if (previous?.isLoading == true && next.hasValue && next.value != null) {
        AppSnackBar.showSuccess(context, context.locale.expenseSubmittedSuccess);
        context.pop();
      } else if (next.hasError) {
        AppSnackBar.showError(context, next.error!.localizedMessage(context));
      }
    });

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: DetailAppBar(title: context.locale.expenseEntry),
      body: _AddExpenseBody(
        formKey: _formKey,
        amountController: _amountController,
        commentsController: _commentsController,
        categoryError: _categoryError,
        onCategorySelected: () => setState(() => _categoryError = false),
        facilityError: _facilityError,
        onFacilitySelected: () => setState(() => _facilityError = false),
        expenseDate: _expenseDate,
        onPickDate: _onPickDate,
        amountError: _amountError,
        onAmountChanged: () {
          if (_amountError) setState(() => _amountError = false);
        },
        paidByError: _paidByError,
        onPaidBySelected: () => setState(() => _paidByError = false),
        isSubmitting: ref.watch(submitFacilityExpenseProvider).isLoading,
        onCancel: () => context.pop(),
        onSubmit: _onSubmit,
      ),
    );
  }
}
