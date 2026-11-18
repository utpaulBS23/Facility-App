import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../core/extensions/failure_localization.dart';
import '../../../../core/utiliity/validation/validation.dart';
import '../../../../domain/entities/login_entity.dart';
import '../../../../domain/entities/master_data_entity.dart';
import '../../../../domain/entities/travel_expense_entity.dart';
import '../../../../domain/entities/visit_entity.dart';
import '../../../core/application_state/session_provider/session_provider.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/detail_app_bar.dart';
import '../../../core/widgets/facility_picker_sheet.dart';
import '../../../core/widgets/form_selector_card.dart';
import '../../../core/widgets/permission_gate.dart';
import '../../../core/widgets/picker_sheet_states.dart';
import '../../../core/widgets/selection_picker_sheet.dart';
import '../riverpod/claim_expense_provider.dart';
import '../widgets/travel_expense_system_generated_card.dart';
import '../../../../core/utils/digits.dart';

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
    final selected = ref
        .read(userSessionProvider)
        ?.accessibleFacilities
        .primaryOrFirst;
    if (selected == null || !mounted) return;
    setState(() => _facilityId = selected.id);
  }

  @override
  void dispose() {
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
    if (result == null || result.facilityId == _facilityId) return;
    // WHY reset reference visit: the reference-visit list is scoped to the
    // destination facility — a previously picked visit may not belong to
    // the newly picked one.
    setState(() {
      _facilityId = result.facilityId;
      _selectedVisit = null;
    });
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

  double get _totalPrice => _legs.fold(0, (sum, leg) => sum + leg.price);

  // WHY a reference visit is required: the backend derives facility/start
  // entirely from the task's recorded travel origin when `task_id` is sent —
  // there's no structured facility/office selector for a standalone claim,
  // so this app no longer offers one (see
  // `User_Visit_Tracking_And_Travel_Expenses_API_Guide 2.md` §2b/§4).
  bool get _isFormValid {
    final legsValid =
        _legs.isNotEmpty &&
        _legs.every(
          (leg) =>
              leg.vehicleTypeItemId != null &&
              leg.distanceKm > 0 &&
              leg.price > 0,
        );

    return _facilityId != null && _selectedVisit != null && legsValid;
  }

  void _onSubmit() {
    final selectedVisit = _selectedVisit;
    if (!_formKey.currentState!.validate() || selectedVisit == null) return;

    final purpose = _purposeController.text.trim();

    final request = CreateTravelExpenseRequestEntity(
      taskId: selectedVisit.id,
      purpose: purpose.isEmpty ? null : purpose,
      // WHY no top-level amount: each leg now carries its own override
      // (legs[].amount, see _LegDraft.toEntity) — sending both is a 422.
      legs: _legs.map((leg) => leg.toEntity()).toList(),
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
    final facilityId = _facilityId;
    final visitsAsync = facilityId == null
        ? const AsyncValue<List<VisitSummaryEntity>>.data([])
        : ref.watch(claimExpenseReferenceVisitsProvider(facilityId));
    final transportModes =
        ref.watch(claimExpenseTransportModesProvider).valueOrNull ??
        const <MasterDataItemEntity>[];
    final facilities =
        ref.watch(userSessionProvider)?.accessibleFacilities ??
        const <AccessibleFacilityEntity>[];
    final isSubmitting = ref.watch(submitTravelExpenseProvider).isLoading;
    final selectedVisit = _selectedVisit;

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
              FormSelectorCard.text(
                title: context.locale.facilityName,
                icon: Icons.location_on_outlined,
                value: _facilityName(facilities, facilityId),
                placeholder: context.locale.selectFacility,
                // WHY disabled: a single-facility session has nothing to
                // pick between — opening the sheet would just show one row
                // and force a redundant tap to confirm what's already set.
                onTap: facilities.length > 1
                    ? () => _onPickFacility(facilities)
                    : null,
              ),
              Gap(spacing.s16),
              visitsAsync.when(
                loading: () => const LinearProgressIndicator(),
                error: (_, _) => const SizedBox.shrink(),
                data: (visits) => FormSelectorCard.text(
                  title: context.locale.referenceVisitOptional,
                  icon: Icons.event_note_outlined,
                  enabled: facilityId != null && visits.isNotEmpty,
                  onTap: () => _onPickVisit(visits),
                  value: selectedVisit == null
                      ? null
                      : _referenceVisitLabel(context, selectedVisit),
                  placeholder: context.locale.none,
                ),
              ),
              // WHY everything past this point is hidden without a
              // reference visit: start/destination, transport legs and
              // purpose all depend on the visit's recorded travel origin —
              // there's nothing valid to fill in until one is picked.
              if (selectedVisit != null) ...[
                Gap(spacing.s16),
                _ReadOnlyField(
                  label: context.locale.startLocation,
                  value: selectedVisit.travelOriginId == null
                      ? context.locale.home
                      : selectedVisit.localizedTravelOriginName(
                              context.languageCode,
                            ) ??
                            '—',
                ),
                Gap(spacing.s16),
                _ReadOnlyField(
                  label: context.locale.destination,
                  value:
                      selectedVisit.localizedOfficeName(
                        context.languageCode,
                      ) ??
                      selectedVisit.localizedFacilityName(
                        context.languageCode,
                      ) ??
                      '—',
                ),
                if (selectedVisit.travelDistanceKm != null) ...[
                  Gap(spacing.s16),
                  TravelExpenseSystemGeneratedCard(
                    distanceKm: selectedVisit.travelDistanceKm,
                  ),
                ],
                Gap(spacing.s16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.locale.transportModes,
                      style: context.textStyle.labelLarge,
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
                  style: OutlinedButton.styleFrom(
                    foregroundColor: context.color.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        context.dimensions.radius.r12,
                      ),
                    ),
                  ),
                ),
                Gap(spacing.s16),
                _ClaimExpenseTotalBar(
                  totalDistanceKm: _totalDistanceKm,
                  totalPrice: _totalPrice,
                ),
                Gap(spacing.s16),
                AppTextField.text(
                  controller: _purposeController,
                  label: context.locale.purpose,
                  hint:
                      '${context.locale.purpose} — ${context.locale.purposeHint}',
                ),
              ],
              Gap(spacing.s24),
              // WHY gated: travel_expense.view opens this page, but only
              // travel_expense.create may actually save a claim — a
              // view-only session sees the form with no way to submit it.
              PermissionGate(
                permissions: [UserPermission.travelExpenseCreate],
                child: FilledButton(
                  onPressed: (isSubmitting || !_isFormValid) ? null : _onSubmit,
                  style: FilledButton.styleFrom(
                    backgroundColor: context.color.primary,
                    disabledBackgroundColor: context.color.primary.withValues(
                      alpha: 0.4,
                    ),
                    foregroundColor: context.color.onPrimary,
                    minimumSize: Size.fromHeight(spacing.s48),
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
                      : Text(context.locale.saveEntry),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _facilityName(List<AccessibleFacilityEntity> facilities, int? id) =>
      facilities
          .cast<AccessibleFacilityEntity?>()
          .firstWhere((f) => f?.id == id, orElse: () => null)
          ?.localizedName(context.languageCode);
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

class _ReadOnlyField extends StatelessWidget {
  const _ReadOnlyField({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final radius = context.dimensions.radius;
    final spacing = context.dimensions.spacing;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: context.textStyle.labelLarge),
        Gap(spacing.s8),
        Container(
          height: spacing.s56,
          decoration: BoxDecoration(
            color: context.color.subtle,
            border: Border.all(color: context.color.borderSubtle),
            borderRadius: BorderRadius.circular(radius.r12),
          ),
          padding: EdgeInsets.symmetric(horizontal: spacing.s16),
          alignment: Alignment.centerLeft,
          child: Text(
            value,
            overflow: TextOverflow.ellipsis,
            style: context.textStyle.bodyMedium,
          ),
        ),
      ],
    );
  }
}

