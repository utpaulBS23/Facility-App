import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../core/extensions/failure_localization.dart';
import '../../../../domain/entities/login_entity.dart';
import '../../../../domain/entities/master_data_entity.dart';
import '../../../../domain/entities/travel_expense_entity.dart';
import '../../../../domain/entities/visit_entity.dart';
import '../../../../core/utiliity/validation/validation.dart';
import '../../../core/application_state/session_provider/session_provider.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/app_dropdown_button_form_field.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/detail_app_bar.dart';
import '../../../core/widgets/facility_picker_sheet.dart';
import '../../../core/widgets/permission_gate.dart';
import '../../../core/widgets/picker_sheet_states.dart';
import '../../../core/widgets/selection_picker_sheet.dart';
import '../riverpod/claim_expense_provider.dart';

part '../widgets/claim_expense_leg_draft.dart';
part '../widgets/claim_expense_leg_row.dart';
part '../widgets/claim_expense_total_bar.dart';

class ClaimExpensePage extends ConsumerStatefulWidget {
  const ClaimExpensePage({super.key});

  @override
  ConsumerState<ClaimExpensePage> createState() => _ClaimExpensePageState();
}

class _ClaimExpensePageState extends ConsumerState<ClaimExpensePage> {
  final _formKey = GlobalKey<FormState>();
  final _startLocationController = TextEditingController();
  final _destinationController = TextEditingController();
  final _purposeController = TextEditingController();
  final List<_LegDraft> _legs = [_LegDraft()];

  int? _facilityId;
  VisitSummaryEntity? _selectedVisit;

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
    _startLocationController.dispose();
    _destinationController.dispose();
    _purposeController.dispose();
    for (final leg in _legs) {
      leg.dispose();
    }
    super.dispose();
  }

  Future<void> _onPickFacility(List<AccessibleFacilityEntity> facilities) async {
    final result = await showModalBottomSheet<({int? facilityId})>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FacilityPickerSheet(
        facilities: facilities,
        selectedFacilityId: _facilityId,
      ),
    );
    if (result == null) return;
    setState(() => _facilityId = result.facilityId);
  }

  Future<void> _onPickVisit(List<VisitSummaryEntity> visits) async {
    final result = await showModalBottomSheet<({VisitSummaryEntity? value})>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ReferenceVisitPickerSheet(
        visits: visits,
        selected: _selectedVisit,
      ),
    );
    if (result != null) setState(() => _selectedVisit = result.value);
  }

  void _onLegChanged() => setState(() {});

  void _onAddLeg() => setState(() => _legs.add(_LegDraft()));

  void _onRemoveLeg(_LegDraft leg) {
    setState(() {
      _legs.remove(leg);
      leg.dispose();
    });
  }

  double get _totalDistanceKm =>
      _legs.fold(0, (sum, leg) => sum + leg.distanceKm);

  double get _totalAmount => _legs.fold(0, (sum, leg) => sum + leg.amount);

  void _onSubmit() {
    final facilityId = _facilityId;
    if (!_formKey.currentState!.validate() || facilityId == null) {
      return;
    }

    final request = CreateTravelExpenseRequestEntity(
      facilityId: facilityId,
      visitId: _selectedVisit?.id,
      startLocation: _startLocationController.text.trim(),
      destination: _destinationController.text.trim(),
      legs: _legs.map((leg) => leg.toEntity()).toList(),
      purpose: _purposeController.text.trim(),
    );

    ref.read(submitTravelExpenseProvider.notifier).submit(request);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(submitTravelExpenseProvider, (previous, next) {
      if (previous?.isLoading == true && next.hasValue && next.value != null) {
        AppSnackBar.showSuccess(
          context,
          context.locale.travelExpenseSubmittedSuccess,
        );
        context.pop();
      } else if (next.hasError) {
        AppSnackBar.showError(context, next.error!.localizedMessage(context));
      }
    });

    final spacing = context.dimensions.spacing;
    final visitsAsync = ref.watch(claimExpenseTodaysVisitsProvider);
    final transportModes =
        ref.watch(claimExpenseTransportModesProvider).valueOrNull ??
        const <MasterDataItemEntity>[];
    final facilities =
        ref.watch(userSessionProvider)?.accessibleFacilities ??
        const <AccessibleFacilityEntity>[];
    final isSubmitting = ref.watch(submitTravelExpenseProvider).isLoading;

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: DetailAppBar(title: context.locale.addTravelExpense),
      body: SafeArea(
        top: false,
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(spacing.s16),
            children: [
              Text(
                context.locale.facilityName,
                style: context.textStyle.labelLarge,
              ),
              Gap(spacing.s8),
              _FacilitySelector(
                facilityName: facilities
                    .cast<AccessibleFacilityEntity?>()
                    .firstWhere(
                      (f) => f?.id == _facilityId,
                      orElse: () => null,
                    )
                    ?.name,
                // WHY disabled: a single-facility session has nothing to
                // pick between — opening the sheet would just show one row
                // and force a redundant tap to confirm what's already set.
                onTap: facilities.length > 1
                    ? () => _onPickFacility(facilities)
                    : null,
              ),
              Gap(spacing.s16),
              Text(
                context.locale.referenceVisitOptional,
                style: context.textStyle.labelLarge,
              ),
              Gap(spacing.s8),
              visitsAsync.when(
                loading: () => const LinearProgressIndicator(),
                error: (_, _) => const SizedBox.shrink(),
                data: (visits) => _ReferenceVisitSelector(
                  selected: _selectedVisit,
                  onTap: () => _onPickVisit(visits),
                ),
              ),
              Gap(spacing.s16),
              AppTextField.text(
                controller: _startLocationController,
                label: context.locale.startLocation,
                hint: context.locale.startLocationHint,
                extraValidations: [RequiredValidation<String>()],
              ),
              Gap(spacing.s16),
              AppTextField.text(
                controller: _destinationController,
                label: context.locale.destination,
                hint: context.locale.destination,
                extraValidations: [RequiredValidation<String>()],
              ),
              Gap(spacing.s20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.locale.transportModes,
                    style: context.textStyle.labelLarge,
                  ),
                  Text(
                    context.locale.transportModeRateHint,
                    style: context.textStyle.bodySmall.copyWith(
                      color: context.color.text.secondary,
                    ),
                  ),
                ],
              ),
              Gap(spacing.s8),
              for (final leg in _legs) ...[
                _ClaimExpenseLegRow(
                  leg: leg,
                  transportModes: transportModes,
                  onChanged: _onLegChanged,
                  onRemove: () => _onRemoveLeg(leg),
                  showRemove: _legs.length > 1,
                ),
                Gap(spacing.s8),
              ],
              TextButton.icon(
                onPressed: _onAddLeg,
                icon: const Icon(Icons.add),
                label: Text(context.locale.addAnotherModeLeg),
              ),
              Gap(spacing.s16),
              _ClaimExpenseTotalBar(
                totalDistanceKm: _totalDistanceKm,
                totalAmount: _totalAmount,
              ),
              Gap(spacing.s16),
              AppTextField.text(
                controller: _purposeController,
                label: context.locale.purpose,
                hint: context.locale.purposeHint,
                extraValidations: [RequiredValidation<String>()],
              ),
              Gap(spacing.s24),
              // WHY gated: travel_expense.view opens this page, but only
              // travel_expense.create may actually save a claim — a
              // view-only session sees the form with no way to submit it.
              PermissionGate(
                permissions: [UserPermission.travelExpenseCreate],
                child: SizedBox(
                  width: double.infinity,
                  height: spacing.s44,
                  child: FilledButton(
                    onPressed: isSubmitting ? null : _onSubmit,
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
                            '${context.locale.saveEntry} — '
                            '৳ ${_totalAmount.toStringAsFixed(0)}',
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}

String _visitTypeLabel(BuildContext context, VisitType type) => switch (type) {
  VisitType.routineInspection => context.locale.routineInspection,
  VisitType.followUp => context.locale.followUp,
};

String _referenceVisitLabel(BuildContext context, VisitSummaryEntity visit) {
  final title = visit.title;
  final name = title != null && title.isNotEmpty
      ? title
      : _visitTypeLabel(context, visit.type);
  return '$name · ${DateFormatter.dayMonthYear(visit.date)}';
}

class _FacilitySelector extends StatelessWidget {
  const _FacilitySelector({required this.facilityName, required this.onTap});

  final String? facilityName;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final radius = context.dimensions.radius;
    final spacing = context.dimensions.spacing;
    final isDisabled = onTap == null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: isDisabled ? context.color.subtle : null,
          border: Border.all(color: context.color.borderSubtle),
          borderRadius: BorderRadius.circular(radius.r6),
        ),
        padding: EdgeInsets.symmetric(horizontal: spacing.s16),
        child: Row(
          children: [
            Expanded(
              child: Text(
                facilityName ?? context.locale.selectFacility,
                overflow: TextOverflow.ellipsis,
                style: facilityName == null
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
    );
  }
}

class _ReferenceVisitSelector extends StatelessWidget {
  const _ReferenceVisitSelector({required this.selected, required this.onTap});

  final VisitSummaryEntity? selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final radius = context.dimensions.radius;
    final spacing = context.dimensions.spacing;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          border: Border.all(color: context.color.borderSubtle),
          borderRadius: BorderRadius.circular(radius.r6),
        ),
        padding: EdgeInsets.symmetric(horizontal: spacing.s16),
        child: Row(
          children: [
            Expanded(
              child: Text(
                selected == null
                    ? context.locale.none
                    : _referenceVisitLabel(context, selected!),
                overflow: TextOverflow.ellipsis,
                style: selected == null
                    ? context.textStyle.bodyMedium.copyWith(
                        color: context.color.text.secondary,
                      )
                    : context.textStyle.bodyMedium,
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: context.color.text.secondary,
            ),
          ],
        ),
      ),
    );
  }
}

// WHY tap-to-select-and-pop, not a native dropdown: mirrors
// FacilityPickerSheet/SelectionPickerSheet's interaction so every
// filter/picker sheet in the app behaves the same way.
class _ReferenceVisitPickerSheet extends StatelessWidget {
  const _ReferenceVisitPickerSheet({
    required this.visits,
    required this.selected,
  });

  final List<VisitSummaryEntity> visits;
  final VisitSummaryEntity? selected;

  @override
  Widget build(BuildContext context) {
    if (visits.isEmpty) {
      return PickerSheetError(message: context.locale.noVisitsFound);
    }
    return SelectionPickerSheet<VisitSummaryEntity?>(
      title: context.locale.referenceVisitOptional,
      options: [
        (value: null, label: context.locale.none),
        for (final visit in visits)
          (value: visit, label: _referenceVisitLabel(context, visit)),
      ],
      isSelected: (value) => value?.id == selected?.id,
    );
  }
}
