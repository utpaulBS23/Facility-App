import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../core/extensions/failure_localization.dart';
import '../../../../domain/entities/login_entity.dart';
import '../../../../domain/entities/travel_expense_entity.dart';
import '../../../../domain/entities/visit_entity.dart';
import '../../../../core/utiliity/validation/validation.dart';
import '../../../core/application_state/session_provider/session_provider.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/widgets/app_dropdown_button_form_field.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/detail_app_bar.dart';
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
  int? _visitId;

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
      visitId: _visitId,
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
              AppDropdownButtonFormField<int>(
                initialValue: _facilityId,
                hint: Text(context.locale.selectFacility),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      context.dimensions.radius.r6,
                    ),
                  ),
                ),
                items: [
                  for (final facility in facilities)
                    DropdownMenuItem(
                      value: facility.id,
                      child: Text(facility.name),
                    ),
                ],
                validator: (value) =>
                    value == null ? context.locale.selectFacility : null,
                onChanged: (value) => setState(() => _facilityId = value),
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
                data: (visits) => AppDropdownButtonFormField<int>(
                  initialValue: _visitId,
                  hint: Text('—'),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        context.dimensions.radius.r6,
                      ),
                    ),
                  ),
                  items: [
                    for (final visit in visits)
                      DropdownMenuItem(
                        value: visit.id,
                        child: Text(
                          '${_visitTypeLabel(context, visit.type)} · ${visit.date}',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                  onChanged: (value) => setState(() => _visitId = value),
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
              SizedBox(
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
            ],
          ),
        ),
      ),
    );
  }

  String _visitTypeLabel(BuildContext context, VisitType type) =>
      switch (type) {
        VisitType.routineInspection => context.locale.routineInspection,
        VisitType.followUp => context.locale.followUp,
      };
}
