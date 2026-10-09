import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../core/extensions/failure_localization.dart';
import '../../../../core/utils/digits.dart';
import '../../../../domain/entities/cash_collection/cash_collection_entity.dart';
import '../../../../domain/entities/cash_collection/cash_collection_payloads.dart';
import '../../../../domain/entities/login_entity.dart';
import '../../../core/application_state/session_provider/session_provider.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/facility_picker_sheet.dart';
import '../../../core/widgets/form_selector_card.dart';
import '../../../core/widgets/permission_gate.dart';
import '../../../core/widgets/photo_picker_card.dart';
import '../../../core/widgets/text/typography.dart';
import '../riverpod/facility_services_provider.dart';
import '../riverpod/submit_cash_collection_provider.dart';
import 'manual_income_services_section.dart';
import 'manual_income_total_bar.dart';

/// "Manual Income" entry form: the daily physical cash count of one facility,
/// broken down by service x gender, plus lump amounts and an evidence photo.
class ManualIncomeForm extends ConsumerStatefulWidget {
  const ManualIncomeForm({super.key});

  @override
  ConsumerState<ManualIncomeForm> createState() => _ManualIncomeFormState();
}

class _ManualIncomeFormState extends ConsumerState<ManualIncomeForm> {
  // WHY a real 0 and not a hint: the amounts are optional and default to 0, so
  // the form shows the value that will actually be sent.
  final _productController = TextEditingController(text: '0');
  final _rentingController = TextEditingController(text: '0');
  final _noteController = TextEditingController();

  int? _facilityId;
  DateTime _date = DateTime.now();

  /// Quantity per `facility_service_id`; a missing row counts as 0.
  Map<int, int> _quantities = {};
  XFile? _photo;

  @override
  void initState() {
    super.initState();
    _facilityId = ref
        .read(userSessionProvider)
        ?.accessibleFacilities
        .primaryOrFirst
        ?.id;
  }

  @override
  void dispose() {
    _productController.dispose();
    _rentingController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  double get _productAmount =>
      Digits.parseDouble(_productController.text.trim()) ?? 0;

  double get _rentingAmount =>
      Digits.parseDouble(_rentingController.text.trim()) ?? 0;

  /// At least one service must have been counted; an all-zero count is not an
  /// entry.
  bool _hasServiceCount(List<FacilityServiceEntity> services) =>
      services.any((service) => (_quantities[service.id] ?? 0) > 0);

  double _total(List<FacilityServiceEntity> services) {
    var sum = _productAmount + _rentingAmount;
    for (final service in services) {
      sum += (_quantities[service.id] ?? 0) * service.price;
    }

    return sum;
  }

  Future<void> _onPickFacility(
    List<AccessibleFacilityEntity> facilities,
  ) async {
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
    setState(() {
      _facilityId = result.facilityId;
      // WHY: quantities belong to the previous facility's services.
      _quantities = {};
    });
  }

  Future<void> _onPickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _date = picked);
  }

  void _onSubmit(List<FacilityServiceEntity> services) {
    final facilityId = _facilityId;
    final photo = _photo;
    if (facilityId == null || photo == null || services.isEmpty) return;

    ref
        .read(submitCashCollectionProvider.notifier)
        .submit(
          CreateCashCollectionRequestEntity(
            facilityId: facilityId,
            collectionDate: _date,
            productSellingAmount: _productAmount,
            rentingOthersAmount: _rentingAmount,
            note: _noteController.text,
            photoPath: photo.path,
            lines: [
              for (final service in services)
                CashCollectionLineEntity(
                  facilityServiceId: service.id,
                  gender: service.gender,
                  quantity: _quantities[service.id] ?? 0,
                ),
            ],
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(submitCashCollectionProvider, (previous, next) {
      if (previous?.isLoading == true && next.hasValue && next.value != null) {
        AppSnackBar.showSuccess(context, context.locale.manualIncomeSubmitted);
        context.pop();
      } else if (next.hasError) {
        AppSnackBar.showError(context, next.error!.localizedMessage(context));
      }
    });

    final spacing = context.dimensions.spacing;
    final facilities =
        ref.watch(userSessionProvider)?.accessibleFacilities ??
        const <AccessibleFacilityEntity>[];
    final facilityId = _facilityId;
    final servicesAsync = facilityId == null
        ? null
        : ref.watch(facilityServicesProvider(facilityId));
    final services = servicesAsync?.asData?.value ?? const [];
    final isSubmitting = ref.watch(submitCashCollectionProvider).isLoading;
    final facilityName = facilities
        .cast<AccessibleFacilityEntity?>()
        .firstWhere((f) => f?.id == facilityId, orElse: () => null)
        ?.localizedName(context.languageCode);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FormSelectorCard.text(
          title: context.locale.selectFacility,
          icon: Icons.location_on_outlined,
          value: facilityName,
          placeholder: context.locale.selectFacility,
          onTap: facilities.length > 1
              ? () => _onPickFacility(facilities)
              : null,
        ),
        Gap(spacing.s16),
        FormSelectorCard.text(
          title: context.locale.expenseDate,
          icon: Icons.calendar_today_outlined,
          value: DateFormatter.shortDate(_date),
          placeholder: context.locale.expenseDate,
          onTap: _onPickDate,
        ),
        Gap(spacing.s16),
        LabelLargeText(context.locale.cashCollectedByService),
        Gap(spacing.s8),
        ManualIncomeServicesSection(
          servicesAsync: servicesAsync,
          quantities: _quantities,
          onChanged: (serviceId, quantity) => setState(
            () => _quantities = {..._quantities, serviceId: quantity},
          ),
          onRetry: facilityId == null
              ? null
              : () => ref.invalidate(facilityServicesProvider(facilityId)),
        ),
        Gap(spacing.s16),
        AppTextField.text(
          controller: _productController,
          label: context.locale.productSellingBdt,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: (_) => setState(() {}),
        ),
        Gap(spacing.s16),
        AppTextField.text(
          controller: _rentingController,
          label: context.locale.rentingOthersBdt,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: (_) => setState(() {}),
        ),
        Gap(spacing.s16),
        AppTextField.description(
          controller: _noteController,
          label: context.locale.noteOptional,
        ),
        Gap(spacing.s16),
        PhotoPickerCard(
          title: '${context.locale.evidencePhoto} *',
          photo: _photo,
          onChanged: (photo) => setState(() => _photo = photo),
        ),
        Gap(spacing.s16),
        ManualIncomeTotalBar(total: _total(services)),
        Gap(spacing.s24),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => context.pop(),
                child: Text(context.locale.cancel),
              ),
            ),
            Gap(spacing.s12),
            Expanded(
              flex: 2,
              child: PermissionGate(
                permissions: const [UserPermission.cashCollectionCreate],
                child: FilledButton(
                  onPressed:
                      isSubmitting ||
                          facilityId == null ||
                          !_hasServiceCount(services) ||
                          _photo == null
                      ? null
                      : () => _onSubmit(services),
                  child: isSubmitting
                      ? SizedBox(
                          width: spacing.s20,
                          height: spacing.s20,
                          child: CircularProgressIndicator(
                            strokeWidth: spacing.s2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              context.color.onPrimary,
                            ),
                          ),
                        )
                      : Text(
                          '${context.locale.saveIncomeEntry} — '
                          '${context.numbers.currency(_total(services))}',
                        ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
