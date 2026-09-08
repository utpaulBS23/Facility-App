import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../core/extensions/failure_localization.dart';
import '../../../../domain/entities/facility_expense/facility_expense_entity.dart';
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
import '../riverpod/expense_dropdowns_provider.dart';
import '../riverpod/submit_facility_expense_provider.dart';

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

  MasterDataItemEntity? _category;
  bool _categoryError = false;
  int? _facilityId;
  bool _facilityError = false;
  DateTime _expenseDate = DateTime.now();
  MasterDataItemEntity? _paidBy;
  bool _paidByError = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _selectDefaultFacility(),
    );
  }

  void _selectDefaultFacility() {
    final facilities = ref.read(userSessionProvider)?.accessibleFacilities;
    if (facilities == null || facilities.isEmpty || !mounted) return;
    final primary = facilities.cast<AccessibleFacilityEntity?>().firstWhere(
      (f) => f?.isPrimary ?? false,
      orElse: () => null,
    );
    setState(() => _facilityId = (primary ?? facilities.first).id);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _commentsController.dispose();
    super.dispose();
  }

  void _onSelectCategory(MasterDataItemEntity category) {
    setState(() {
      _category = category;
      _categoryError = false;
    });
  }

  void _onSelectPaidBy(MasterDataItemEntity paidBy) {
    setState(() {
      _paidBy = paidBy;
      _paidByError = false;
    });
  }

  Future<void> _onPickFacility(List<AccessibleFacilityEntity> facilities) async {
    final result = await showModalBottomSheet<int?>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _FacilityListSheet(
        facilities: facilities,
        selectedFacilityId: _facilityId,
      ),
    );
    if (result == null) return;
    setState(() {
      _facilityId = result;
      _facilityError = false;
    });
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
    final categoryOk = _category != null;
    final paidByOk = _paidBy != null;
    final facilityOk = _facilityId != null;

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
            facilityId: _facilityId!,
            category: _category!.value,
            amount: amount,
            expenseDate: _expenseDate,
            paidBy: _paidBy!.value,
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

    final spacing = context.dimensions.spacing;
    final facilities =
        ref.watch(userSessionProvider)?.accessibleFacilities ??
        const <AccessibleFacilityEntity>[];
    final facilityName = facilities
        .cast<AccessibleFacilityEntity?>()
        .firstWhere((f) => f?.id == _facilityId, orElse: () => null)
        ?.name;
    final categoriesAsync = ref.watch(expenseCategoryOptionsProvider);
    final paymentMethodsAsync = ref.watch(paymentMethodOptionsProvider);
    final isSubmitting = ref.watch(submitFacilityExpenseProvider).isLoading;

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: DetailAppBar(title: context.locale.expenseEntry),
      body: Form(
        key: _formKey,
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
                selected: _category,
                hasError: _categoryError,
                onChanged: _onSelectCategory,
              ),
            ),
            Gap(spacing.s16),
            LabelLargeText(context.locale.selectFacility),
            Gap(spacing.s8),
            _DropdownField(
              value: facilityName,
              hint: context.locale.selectFacility,
              hasError: _facilityError,
              onTap: facilities.length > 1
                  ? () => _onPickFacility(facilities)
                  : null,
            ),
            Gap(spacing.s16),
            LabelLargeText(context.locale.expenseDate),
            Gap(spacing.s8),
            _DropdownField(
              value: DateFormatter.shortDate(_expenseDate),
              hint: context.locale.expenseDate,
              onTap: _onPickDate,
            ),
            Gap(spacing.s16),
            AppTextField.text(
              controller: _amountController,
              label: context.locale.amountBdt,
              hint: context.locale.enterAmount,
            ),
            Gap(spacing.s16),
            LabelLargeText(context.locale.paidBy),
            Gap(spacing.s8),
            paymentMethodsAsync.when(
              loading: () => const LinearProgressIndicator(),
              error: (_, _) => BodySmallText(
                context.locale.paidBy,
                color: context.color.error,
              ),
              data: (methods) => _MasterDataOptionSelector(
                options: methods,
                selected: _paidBy,
                hasError: _paidByError,
                onChanged: _onSelectPaidBy,
              ),
            ),
            Gap(spacing.s16),
            AppTextField.description(
              controller: _commentsController,
              label: '${context.locale.comments} (${context.locale.optional})',
              hint: context.locale.commentsHint,
            ),
            Gap(spacing.s24),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 52,
                    child: OutlinedButton(
                      onPressed: () => context.pop(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: context.color.error,
                        side: BorderSide(color: context.color.error),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            context.dimensions.radius.r12,
                          ),
                        ),
                      ),
                      child: Text(
                        context.locale.cancel,
                        style: context.textStyle.labelLarge.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                Gap(spacing.s12),
                Expanded(
                  child: PermissionGate(
                    permissions: [UserPermission.facilityExpenseCreate],
                    child: SizedBox(
                      height: 52,
                      child: FilledButton(
                        onPressed: isSubmitting ? null : _onSubmit,
                        style: FilledButton.styleFrom(
                          backgroundColor: context.color.primary,
                          disabledBackgroundColor: context.color.primary
                              .withValues(alpha: 0.4),
                          foregroundColor: context.color.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              context.dimensions.radius.r12,
                            ),
                          ),
                        ),
                        child: isSubmitting
                            ? SizedBox(
                                width: spacing.s20,
                                height: spacing.s20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    context.color.onPrimary,
                                  ),
                                ),
                              )
                            : Text(
                                context.locale.submit,
                                style: context.textStyle.labelLarge.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Gap(spacing.s16),
          ],
        ),
      ),
    );
  }
}

class _DropdownField extends StatelessWidget {
  const _DropdownField({
    required this.value,
    required this.hint,
    this.onTap,
    this.hasError = false,
  });

  final String? value;
  final String hint;
  final VoidCallback? onTap;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    final radius = context.dimensions.radius;
    final spacing = context.dimensions.spacing;
    final isDisabled = onTap == null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 52,
            decoration: BoxDecoration(
              color: isDisabled ? context.color.subtle : null,
              border: Border.all(
                color: hasError
                    ? context.color.error
                    : context.color.borderSubtle,
              ),
              borderRadius: BorderRadius.circular(radius.r12),
            ),
            padding: EdgeInsets.symmetric(horizontal: spacing.s16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value ?? hint,
                    overflow: TextOverflow.ellipsis,
                    style: value == null
                        ? context.textStyle.bodyMedium.copyWith(
                            color: context.color.text.secondary,
                          )
                        : context.textStyle.bodyMedium,
                  ),
                ),
                if (!isDisabled)
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: context.color.text.secondary,
                  ),
              ],
            ),
          ),
        ),
        if (hasError) ...[
          Gap(spacing.s4),
          BodySmallText(
            context.locale.fieldRequired,
            color: context.color.error,
          ),
        ],
      ],
    );
  }
}

class _FacilityListSheet extends StatelessWidget {
  const _FacilityListSheet({
    required this.facilities,
    required this.selectedFacilityId,
  });

  final List<AccessibleFacilityEntity> facilities;
  final int? selectedFacilityId;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.75,
      ),
      decoration: BoxDecoration(
        color: context.color.scaffoldBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(radius.r12)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Gap(spacing.s12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: context.color.borderSubtle,
              borderRadius: BorderRadius.circular(radius.r4),
            ),
          ),
          Gap(spacing.s16),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: spacing.s16),
            child: LabelLargeText(context.locale.selectFacility),
          ),
          Gap(spacing.s16),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.fromLTRB(
                spacing.s16,
                0,
                spacing.s16,
                spacing.s16,
              ),
              itemCount: facilities.length,
              separatorBuilder: (_, _) => Gap(spacing.s12),
              itemBuilder: (context, index) {
                final facility = facilities[index];
                final isSelected = facility.id == selectedFacilityId;
                return GestureDetector(
                  onTap: () => Navigator.of(context).pop(facility.id),
                  child: Container(
                    padding: EdgeInsets.all(spacing.s16),
                    decoration: BoxDecoration(
                      color: context.color.onPrimary,
                      border: Border.all(
                        color: isSelected
                            ? context.color.primary
                            : context.color.borderSubtle,
                      ),
                      borderRadius: BorderRadius.circular(radius.r12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: LabelLargeText(
                            facility.name,
                            color: isSelected
                                ? context.color.primary
                                : context.color.text.primary,
                          ),
                        ),
                        if (isSelected)
                          Icon(
                            Icons.check_circle_rounded,
                            color: context.color.primary,
                            size: 20,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
