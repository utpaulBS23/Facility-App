import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/app_permission.dart';
import '../../../../domain/entities/shift_slot_entity.dart';
import '../../../../domain/entities/stock/facility_stock_target_entity.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/app_error_widget.dart';
import '../../../core/widgets/permission_gate.dart';
import '../../../core/widgets/text/typography.dart';
import '../../shift/riverpod/shift_slots_provider.dart';
import '../models/update_stock_page_args.dart';
import '../riverpod/facility_stock_targets_provider.dart';
import '../widgets/shimmer/shimmer_box.dart';

part '../widgets/shimmer/stock_item_shimmer.dart';
part '../widgets/stock_body.dart';
part '../widgets/stock_footer_bar.dart';
part '../widgets/stock_item_card.dart';

class StockPage extends ConsumerStatefulWidget {
  const StockPage({super.key});

  @override
  ConsumerState<StockPage> createState() => _StockPageState();
}

class _StockPageState extends ConsumerState<StockPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchActiveShift());
  }

  void _fetchActiveShift() {
    ref
        .read(shiftSlotsProvider.notifier)
        .fetch(date: DateFormat('yyyy-MM-dd').format(DateTime.now()));
  }

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

  void _onUpdateStockBalances(int facilityId, int shiftAssignmentId) {
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
  Widget build(BuildContext context) {
    final slotsAsync = ref.watch(shiftSlotsProvider);

    return slotsAsync.when(
      loading: () => _scaffold(context, body: const _StockListShimmer()),
      error: (err, _) => _scaffold(
        context,
        body: AppErrorWidget(message: err.toString(), onRetry: _fetchActiveShift),
      ),
      data: (slots) {
        final facilityId = slots?.facility?.id;
        if (facilityId == null) {
          return _scaffold(
            context,
            body: AppErrorWidget(message: context.locale.noActiveShift),
          );
        }

        final shiftAssignmentId = _assignmentIdFor(slots!);

        return _scaffold(
          context,
          body: _StockBody(facilityId: facilityId),
          bottomNavigationBar: shiftAssignmentId == null
              ? null
              : PermissionGate(
                  permissions: const [UserPermission.shiftStockCountCreate],
                  child: _StockFooterBar(
                    onUpdateStockBalances: () => _onUpdateStockBalances(
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
