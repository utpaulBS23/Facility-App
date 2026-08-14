import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/app_permission.dart';
import '../../../../domain/entities/shift_slot_entity.dart';
import '../../../../domain/entities/stock/shift_stock_count_entity.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/app_error_widget.dart';
import '../../../core/widgets/permission_gate.dart';
import '../../../core/widgets/text/typography.dart';
import '../riverpod/shift_stock_counts_provider.dart';
import '../riverpod/stock_shift_slots_provider.dart';
import '../utils/stock_count_utils.dart';
import '../../shift/update_stock/view/update_stock_page.dart';

part '../widgets/stock_footer_bar.dart';
part '../widgets/stock_item_card.dart';
part '../widgets/stock_summary_row.dart';

class StockPageArgs {
  const StockPageArgs({
    required this.facilityId,
    this.shiftAssignmentId,
  });

  final int facilityId;
  final int? shiftAssignmentId;
}

class StockPage extends ConsumerWidget {
  const StockPage({super.key, this.args});

  final StockPageArgs? args;

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

  Scaffold _scaffold(
    BuildContext context, {
    required Widget body,
    Widget? bottomNavigationBar,
  }) {
    final color = context.color;

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
      body: body,
      bottomNavigationBar: bottomNavigationBar,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final explicitFacilityId = args?.facilityId;
    final explicitAssignmentId = args?.shiftAssignmentId;

    if (explicitFacilityId != null) {
      return _scaffold(
        context,
        body: _StockBody(facilityId: explicitFacilityId),
        bottomNavigationBar: explicitAssignmentId == null
            ? null
            : PermissionGate(
                permissions: const [UserPermission.shiftStockCountCreate],
                child: _StockFooterBar(
                  onUpdateStockBalances: () => _onUpdateStockBalances(
                    context,
                    explicitFacilityId,
                    explicitAssignmentId,
                  ),
                ),
              ),
      );
    }

    final slotsAsync = ref.watch(stockShiftSlotsProvider(_today));

    return slotsAsync.when(
      loading: () => _scaffold(
        context,
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (err, _) => _scaffold(
        context,
        body: AppErrorWidget(
          message: err.toString(),
          onRetry: () => ref.invalidate(stockShiftSlotsProvider(_today)),
        ),
      ),
      data: (slots) {
        final facilityId = slots.facility?.id;
        if (facilityId == null) {
          return _scaffold(
            context,
            body: AppErrorWidget(message: context.locale.noActiveShift),
          );
        }

        final shiftAssignmentId = _assignmentIdFor(slots);

        return _scaffold(
          context,
          body: _StockBody(facilityId: facilityId),
          bottomNavigationBar: shiftAssignmentId == null
              ? null
              : PermissionGate(
                  permissions: const [UserPermission.shiftStockCountCreate],
                  child: _StockFooterBar(
                    onUpdateStockBalances: () => _onUpdateStockBalances(
                      context,
                      facilityId,
                      shiftAssignmentId,
                    ),
                  ),
                ),
        );
      },
    );
  }
}

class _StockBody extends ConsumerWidget {
  const _StockBody({required this.facilityId});

  final int facilityId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = context.dimensions.spacing;
    final color = context.color;
    final countsAsync = ref.watch(
      shiftStockCountsProvider(facilityId: facilityId),
    );

    return countsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => AppErrorWidget(
        message: err.toString(),
        onRetry: () =>
            ref.invalidate(shiftStockCountsProvider(facilityId: facilityId)),
      ),
      data: (history) {
        final latestItems = latestStockCountPerItem(history);

        if (latestItems.isEmpty) {
          return Center(
            child: Text(
              context.locale.noStockCountRecorded,
              style: context.textStyle.bodyMedium.copyWith(
                color: color.text.secondary,
              ),
            ),
          );
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(spacing.s16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _StockSummaryRow(
                totalItems: latestItems.length,
                lastUpdated: latestItems.first.reportedDate,
              ),
              Gap(spacing.s16),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: latestItems.length,
                separatorBuilder: (context, index) => Gap(spacing.s12),
                itemBuilder: (context, index) =>
                    _StockItemCard(item: latestItems[index]),
              ),
            ],
          ),
        );
      },
    );
  }
}
