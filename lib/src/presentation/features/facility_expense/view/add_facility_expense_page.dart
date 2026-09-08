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
part '../widgets/expense_dropdown_field.dart';
part '../widgets/expense_facility_list_sheet.dart';
part '../widgets/expense_master_data_selector.dart';

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
  bool _paidByError = false;

  @override
  void dispose() {
    _amountController.dispose();
    _commentsController.dispose();
    super.dispose();
  }

  // WHY the cascade resets downstream selections: category/facility/paid-by
  // are unrelated data (no field's options actually depend on another's
  // value) so this is a pure UX-ordering rule — but once a later step has
  // already been filled, changing an earlier one could leave a stale,
  // no-longer-reviewed choice behind, so it's cleared instead.
  void _onSelectCategory(MasterDataItemEntity category) {
    setState(() => _categoryError = false);
    ref.read(selectedExpenseCategoryProvider.notifier).select(category);
  }

  void _onSelectPaidBy(MasterDataItemEntity paidBy) {
    setState(() => _paidByError = false);
    ref.read(selectedExpensePaidByProvider.notifier).select(paidBy);
  }

  Future<void> _onPickFacility(List<AccessibleFacilityEntity> facilities) async {
    final result = await showModalBottomSheet<int?>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _FacilityListSheet(
        facilities: facilities,
        selectedFacilityId: ref.read(selectedExpenseFacilityProvider),
      ),
    );
    if (result == null) return;
    setState(() => _facilityError = false);
    ref.read(selectedExpenseFacilityProvider.notifier).select(result);
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

    final categoryOk = category != null;
    final paidByOk = paidBy != null;
    final facilityOk = facilityId != null;

    setState(() {
      _categoryError = !categoryOk;
      _paidByError = !paidByOk;
      _facilityError = !facilityOk;
    });

    if (!_formKey.currentState!.validate() ||
        !categoryOk ||
        !paidByOk ||
        !facilityOk) {
      return;
    }

    final amount = double.tryParse(_amountController.text.trim()) ?? 0;
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

    final facilities =
        ref.watch(userSessionProvider)?.accessibleFacilities ??
        const <AccessibleFacilityEntity>[];
    final category = ref.watch(selectedExpenseCategoryProvider);
    final facilityId = ref.watch(selectedExpenseFacilityProvider);
    final paidBy = ref.watch(selectedExpensePaidByProvider);
    final facilityName = facilities
        .cast<AccessibleFacilityEntity?>()
        .firstWhere((f) => f?.id == facilityId, orElse: () => null)
        ?.name;

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: DetailAppBar(title: context.locale.expenseEntry),
      body: _AddExpenseBody(
        formKey: _formKey,
        amountController: _amountController,
        commentsController: _commentsController,
        categoriesAsync: ref.watch(expenseCategoryOptionsProvider),
        paymentMethodsAsync: ref.watch(paymentMethodOptionsProvider),
        category: category,
        categoryError: _categoryError,
        onSelectCategory: _onSelectCategory,
        facilityName: facilityName,
        facilities: facilities,
        facilityEnabled: category != null,
        facilityError: _facilityError,
        onPickFacility: () => _onPickFacility(facilities),
        expenseDate: _expenseDate,
        dateEnabled: facilityId != null,
        onPickDate: _onPickDate,
        amountEnabled: facilityId != null,
        paidBy: paidBy,
        paidByError: _paidByError,
        onSelectPaidBy: _onSelectPaidBy,
        isSubmitting: ref.watch(submitFacilityExpenseProvider).isLoading,
        onCancel: () => context.pop(),
        onSubmit: _onSubmit,
      ),
    );
  }
}
