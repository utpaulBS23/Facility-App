import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/app_permission.dart';
import '../../../../domain/entities/facility_entity.dart';
import '../../../../domain/entities/shift_slot_entity.dart';
import '../../../../domain/entities/stock/facility_stock_balance_entity.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/app_error_widget.dart';
import '../../../core/widgets/permission_gate.dart';
import '../../../core/widgets/status_pill.dart';
import '../../../core/widgets/text/typography.dart';
import '../../roster/riverpod/facility_list_provider.dart';
import '../riverpod/facility_stock_balance_provider.dart';
import '../riverpod/stock_shift_slots_provider.dart';
import '../../shift/update_stock/view/update_stock_page.dart';

part '../widgets/facility_balance_card.dart';
part '../widgets/stock_footer_bar.dart';
part '../widgets/stock_summary_row.dart';

class StockPageArgs {
  const StockPageArgs({
    required this.facilityId,
    this.shiftAssignmentId,
  });

  final int facilityId;
  final int? shiftAssignmentId;
}

class StockPage extends ConsumerStatefulWidget {
  const StockPage({super.key, this.args});

  final StockPageArgs? args;

  @override
  ConsumerState<StockPage> createState() => _StockPageState();
}

class _StockPageState extends ConsumerState<StockPage> {
  int? _selectedFacilityId;

  @override
  void initState() {
    super.initState();
    _selectedFacilityId = widget.args?.facilityId;
    Future.microtask(() => ref.read(facilityListProvider.notifier).fetch());
  }

  String get _today => DateFormat('yyyy-MM-dd').format(DateTime.now());

  int? _assignmentIdFor(ShiftSlotsEntity data) {
    final activeSlot = data.activeSlot;
    if (activeSlot == null) return null;

    for (final slot in data.slots) {
      if (slot.shiftSlotId == activeSlot.shiftSlotId) {
        return slot.me?.assignmentId;
      }
    }

    return null;
  }

  void _onBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.goNamed(Routes.shift);
    }
  }

  void _onUpdateStockBalances(
    BuildContext context,
    int facilityId,
    int shiftAssignmentId,
  ) {
    context.pushNamed(
      Routes.updateStock,
      extra: UpdateStockPageArgs(
        facilityId: facilityId,
        shiftAssignmentId: shiftAssignmentId,
      ),
    );
  }

  void _showFacilitySelector(BuildContext context, List<FacilityEntity> facilities) {
    showModalBottomSheet<void>(
      context: context,
      builder: (bottomSheetContext) {
        final color = context.color;
        final spacing = context.dimensions.spacing;

        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.all(spacing.s16),
                child: Headline2xlTinyText(context.locale.selectFacility),
              ),
              const Divider(height: 1),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: facilities.length,
                  itemBuilder: (context, index) {
                    final facility = facilities[index];
                    final isSelected = facility.id == _selectedFacilityId;

                    return ListTile(
                      title: Text(facility.name),
                      trailing: isSelected
                          ? Icon(Icons.check_circle_rounded, color: color.primary)
                          : null,
                      onTap: () {
                        setState(() {
                          _selectedFacilityId = facility.id;
                        });
                        Navigator.pop(bottomSheetContext);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = context.color;
    final spacing = context.dimensions.spacing;
    final facilitiesAsync = ref.watch(facilityListProvider);
    final facilities = facilitiesAsync.valueOrNull ?? const [];

    final activeSlotsAsync = ref.watch(stockShiftSlotsProvider(_today));
    final activeShiftFacilityId = activeSlotsAsync.valueOrNull?.facility?.id;
    final activeAssignmentId = activeSlotsAsync.valueOrNull != null
        ? _assignmentIdFor(activeSlotsAsync.valueOrNull!)
        : widget.args?.shiftAssignmentId;

    _selectedFacilityId ??= _resolveInitialFacilityId(activeShiftFacilityId, facilities);

    final selectedFacilityName = facilities
            .where((f) => f.id == _selectedFacilityId)
            .firstOrNull
            ?.name ??
        '';

    return Scaffold(
      backgroundColor: color.scaffoldBackground,
      appBar: AppBar(
        leading: AppBackButton(onTap: () => _onBack(context)),
        leadingWidth: AppBackButton.width,
        title: Headline2xlTinyText(context.locale.stock),
        centerTitle: true,
        backgroundColor: color.onPrimary,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(spacing.s16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (facilities.isNotEmpty) ...[
              _FacilitySelectorCard(
                facilityName: selectedFacilityName.isEmpty
                    ? context.locale.selectFacility
                    : selectedFacilityName,
                onTap: () => _showFacilitySelector(context, facilities),
              ),
              Gap(spacing.s16),
            ],
            _FacilityStockBalanceBody(facilityId: _selectedFacilityId),
          ],
        ),
      ),
      bottomNavigationBar: activeShiftFacilityId != null &&
              activeAssignmentId != null &&
              activeShiftFacilityId == _selectedFacilityId
          ? PermissionGate(
              permissions: const [UserPermission.shiftStockCountCreate],
              child: _StockFooterBar(
                onUpdateStockBalances: () => _onUpdateStockBalances(
                  context,
                  activeShiftFacilityId,
                  activeAssignmentId,
                ),
              ),
            )
          : null,
    );
  }

  int? _resolveInitialFacilityId(
    int? activeShiftFacilityId,
    List<FacilityEntity> facilities,
  ) {
    if (widget.args?.facilityId != null) return widget.args!.facilityId;
    if (activeShiftFacilityId != null) return activeShiftFacilityId;
    if (facilities.isNotEmpty) return facilities.first.id;
    return null;
  }
}

class _FacilitySelectorCard extends StatelessWidget {
  const _FacilitySelectorCard({
    required this.facilityName,
    required this.onTap,
  });

  final String facilityName;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final color = context.color;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(radius.r12),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: spacing.s16,
          vertical: spacing.s12,
        ),
        decoration: BoxDecoration(
          color: color.onPrimary,
          borderRadius: BorderRadius.circular(radius.r12),
          border: Border.all(color: color.borderSubtle),
        ),
        child: Row(
          children: [
            Icon(
              Icons.location_on_outlined,
              color: color.primary,
              size: spacing.s20,
            ),
            Gap(spacing.s12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.locale.selectFacility,
                    style: context.textStyle.bodySmall.copyWith(
                      color: color.text.secondary,
                    ),
                  ),
                  Gap(spacing.s2),
                  Text(
                    facilityName,
                    style: context.textStyle.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color.text.primary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: color.text.secondary,
              size: spacing.s24,
            ),
          ],
        ),
      ),
    );
  }
}

class _FacilityStockBalanceBody extends ConsumerWidget {
  const _FacilityStockBalanceBody({required this.facilityId});

  final int? facilityId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = context.dimensions.spacing;
    final color = context.color;

    if (facilityId == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final balanceAsync = ref.watch(
      facilityStockBalanceProvider(facilityId: facilityId),
    );

    return balanceAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => AppErrorWidget(
        message: err.toString(),
        onRetry: () => ref.invalidate(
          facilityStockBalanceProvider(facilityId: facilityId),
        ),
      ),
      data: (page) {
        final items = page.items;
        final summary = page.summary;

        if (items.isEmpty) {
          return Center(
            child: Text(
              context.locale.noStockCountRecorded,
              style: context.textStyle.bodyMedium.copyWith(
                color: color.text.secondary,
              ),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (summary != null)
              Row(
                children: [
                  Expanded(
                    child: _StockStatTile(
                      value: '${summary.okCount}',
                      label: 'OK',
                    ),
                  ),
                  Gap(spacing.s12),
                  Expanded(
                    child: _StockStatTile(
                      value: '${summary.lowCount}',
                      label: 'Low',
                    ),
                  ),
                  Gap(spacing.s12),
                  Expanded(
                    child: _StockStatTile(
                      value: '${summary.outCount}',
                      label: 'Out of stock',
                    ),
                  ),
                ],
              )
            else
              _StockSummaryRow(
                totalItems: items.length,
                lastUpdated: items.first.lastCountedAt != null &&
                        items.first.lastCountedAt!.length >= 10
                    ? items.first.lastCountedAt!.substring(0, 10)
                    : 'N/A',
              ),
            Gap(spacing.s16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              separatorBuilder: (context, index) => Gap(spacing.s12),
              itemBuilder: (context, index) =>
                  _FacilityBalanceCard(item: items[index]),
            ),
          ],
        );
      },
    );
  }
}
