import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../core/extensions/failure_localization.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/login_entity.dart';
import '../../../../domain/entities/master_data_entity.dart';
import '../../../../domain/entities/travel_expense_entity.dart';
import '../../../../domain/entities/visit_entity.dart';
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
import '../../../core/widgets/text/typography.dart';
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
  final _purposeController = TextEditingController();
  final _amountController = TextEditingController();
  final List<_LegDraft> _legs = [_LegDraft()];

  int? _facilityId;
  VisitSummaryEntity? _selectedVisit;

  // WHY these only matter without a reference visit: when taskId is sent,
  // the backend derives facility/start entirely from the task's recorded
  // travel origin — see CreateTravelExpenseRequestEntity's WHY.
  TravelExpenseStartType? _startType;
  int? _startFacilityId;
  bool _startTypeError = false;

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
    _purposeController.dispose();
    _amountController.dispose();
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

  Future<void> _onPickStartFacility(
    List<AccessibleFacilityEntity> facilities,
  ) async {
    final result = await showModalBottomSheet<({int? facilityId})>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FacilityPickerSheet(
        facilities: facilities,
        selectedFacilityId: _startFacilityId,
      ),
    );
    if (result == null) return;
    setState(() => _startFacilityId = result.facilityId);
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

  void _onStartTypeChanged(TravelExpenseStartType type) {
    setState(() {
      _startType = type;
      _startTypeError = false;
      if (type != TravelExpenseStartType.facility) _startFacilityId = null;
    });
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

  int? get _currentUserId =>
      ref.read(getCurrentUserUseCaseProvider).call()?.id;

  void _onSubmit() {
    final facilityId = _facilityId;
    final selectedVisit = _selectedVisit;
    final startType = _startType;
    final needsStandaloneFields = selectedVisit == null;

    final startId = switch (startType) {
      TravelExpenseStartType.home => _currentUserId,
      TravelExpenseStartType.facility => _startFacilityId,
      TravelExpenseStartType.office || null => null,
    };

    final standaloneValid =
        !needsStandaloneFields ||
        (facilityId != null && startType != null && startId != null);

    setState(
      () => _startTypeError = needsStandaloneFields && startType == null,
    );

    if (!_formKey.currentState!.validate() ||
        facilityId == null ||
        !standaloneValid) {
      return;
    }

    final amountOverride = double.tryParse(_amountController.text.trim());
    final purpose = _purposeController.text.trim();

    final request = CreateTravelExpenseRequestEntity(
      taskId: selectedVisit?.id,
      facilityId: needsStandaloneFields ? facilityId : null,
      startType: needsStandaloneFields ? startType : null,
      startId: needsStandaloneFields ? startId : null,
      purpose: purpose.isEmpty ? null : purpose,
      amount: amountOverride,
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
              Text(
                context.locale.facilityName,
                style: context.textStyle.labelLarge,
              ),
              Gap(spacing.s8),
              _FacilitySelector(
                facilityName: _facilityName(facilities, facilityId),
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
                  selected: selectedVisit,
                  onTap: facilityId == null || visits.isEmpty
                      ? null
                      : () => _onPickVisit(visits),
                ),
              ),
              Gap(spacing.s16),
              if (selectedVisit != null) ...[
                _ReadOnlyField(
                  label: context.locale.startLocation,
                  value: selectedVisit.travelOriginName ?? '—',
                ),
                Gap(spacing.s16),
                _ReadOnlyField(
                  label: context.locale.destination,
                  value: selectedVisit.facilityName,
                ),
                Gap(spacing.s16),
              ] else ...[
                Text(
                  context.locale.startType,
                  style: context.textStyle.labelLarge,
                ),
                Gap(spacing.s8),
                _StartTypeSelector(
                  selected: _startType,
                  hasError: _startTypeError,
                  onChanged: _onStartTypeChanged,
                ),
                if (_startType == TravelExpenseStartType.facility) ...[
                  Gap(spacing.s12),
                  _FacilitySelector(
                    facilityName: _facilityName(facilities, _startFacilityId),
                    hint: context.locale.startFacility,
                    onTap: () => _onPickStartFacility(facilities),
                  ),
                ],
                Gap(spacing.s16),
              ],
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
              ),
              Gap(spacing.s16),
              _ClaimExpenseTotalBar(totalDistanceKm: _totalDistanceKm),
              Gap(spacing.s16),
              AppTextField.text(
                controller: _purposeController,
                label: context.locale.purpose,
                hint: context.locale.purposeHint,
              ),
              Gap(spacing.s16),
              TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  labelText: context.locale.amountOverrideOptional,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      context.dimensions.radius.r6,
                    ),
                  ),
                ),
              ),
              Gap(spacing.s24),
              // WHY gated: travel_expense.view opens this page, but only
              // travel_expense.create may actually save a claim — a
              // view-only session sees the form with no way to submit it.
              PermissionGate(
                permissions: [UserPermission.travelExpenseCreate],
                child: FilledButton(
                  onPressed: isSubmitting ? null : _onSubmit,
                  style: FilledButton.styleFrom(
                    backgroundColor: context.color.primary,
                    disabledBackgroundColor: context.color.primary.withValues(
                      alpha: 0.4,
                    ),
                    foregroundColor: context.color.onPrimary,
                    minimumSize: const Size.fromHeight(52),
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
          ?.name;
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
  const _FacilitySelector({
    required this.facilityName,
    required this.onTap,
    this.hint,
  });

  final String? facilityName;
  final VoidCallback? onTap;
  final String? hint;

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
                facilityName ?? hint ?? context.locale.selectFacility,
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
          height: 52,
          decoration: BoxDecoration(
            color: context.color.subtle,
            border: Border.all(color: context.color.borderSubtle),
            borderRadius: BorderRadius.circular(radius.r6),
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

class _StartTypeSelector extends StatelessWidget {
  const _StartTypeSelector({
    required this.selected,
    required this.hasError,
    required this.onChanged,
  });

  final TravelExpenseStartType? selected;
  final bool hasError;
  final ValueChanged<TravelExpenseStartType> onChanged;

  // WHY facility/home only: `office` is a valid backend start_type, but this
  // app has no endpoint to list offices to pick a start_id from — add it
  // here once one exists.
  static const _options = [
    TravelExpenseStartType.home,
    TravelExpenseStartType.facility,
  ];

  String _label(BuildContext context, TravelExpenseStartType type) =>
      switch (type) {
        TravelExpenseStartType.home => context.locale.home,
        TravelExpenseStartType.facility => context.locale.facility,
        TravelExpenseStartType.office => '',
      };

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            for (final type in _options) ...[
              Expanded(
                child: GestureDetector(
                  onTap: () => onChanged(type),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    height: 44,
                    decoration: BoxDecoration(
                      color: selected == type
                          ? context.color.primary.withValues(alpha: 0.08)
                          : context.color.onPrimary,
                      borderRadius: BorderRadius.circular(radius.r6),
                      border: Border.all(
                        color: hasError
                            ? context.color.error
                            : selected == type
                            ? context.color.primary
                            : context.color.borderSubtle,
                        width: selected == type ? 1.5 : 1,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _label(context, type),
                      style: context.textStyle.bodyMedium.copyWith(
                        color: selected == type
                            ? context.color.primary
                            : context.color.text.secondary,
                      ),
                    ),
                  ),
                ),
              ),
              if (type != _options.last) Gap(spacing.s8),
            ],
          ],
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
