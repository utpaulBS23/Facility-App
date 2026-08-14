import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/app_permission.dart';
import '../../../../domain/entities/stock/shift_stock_count_entity.dart';
import '../../../../domain/entities/supply/stock_item_entity.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/app_error_widget.dart';
import '../../../core/widgets/permission_gate.dart';
import '../../../core/widgets/text/typography.dart';
import '../../supply/riverpod/item_catalog_provider.dart';
import '../riverpod/shift_stock_counts_provider.dart';
import '../riverpod/submit_shift_stock_count_provider.dart';
import '../utils/stock_count_utils.dart';
import '../widgets/update_stock_form_entry.dart';

part '../widgets/instruction_alert_banner.dart';
part '../widgets/update_stock_footer_bar.dart';
part '../widgets/update_stock_form_card.dart';

class UpdateStockPageArgs {
  const UpdateStockPageArgs({
    required this.facilityId,
    required this.shiftAssignmentId,
  });

  final int facilityId;
  final int shiftAssignmentId;
}

class UpdateStockPage extends ConsumerStatefulWidget {
  const UpdateStockPage({super.key, required this.args});

  final UpdateStockPageArgs args;

  @override
  ConsumerState<UpdateStockPage> createState() => _UpdateStockPageState();
}

class _UpdateStockPageState extends ConsumerState<UpdateStockPage> {
  final Map<int, ShiftStockCountItemFormEntry> _formEntries = {};

  @override
  void initState() {
    super.initState();
    ref.listenManual(submitShiftStockCountProvider, _onSubmitStateChanged);
  }

  @override
  void dispose() {
    for (final entry in _formEntries.values) {
      entry.dispose();
    }
    super.dispose();
  }

  void _onSubmitStateChanged(
    AsyncValue<List<ShiftStockCountEntity>?>? previous,
    AsyncValue<List<ShiftStockCountEntity>?> next,
  ) {
    next.whenOrNull(
      data: (value) {
        if (value == null || !mounted) return;

        AppSnackBar.showSuccess(
          context,
          context.locale.stockCountSubmittedSuccess,
        );
        context.pop();
      },
      error: (error, _) {
        if (!mounted) return;

        AppSnackBar.showError(context, context.locale.somethingWentWrong);
      },
    );
  }

  void _onSave() {
    final entries = _formEntries.values.toList();
    if (entries.isEmpty) return;

    ref
        .read(submitShiftStockCountProvider.notifier)
        .submit(shiftAssignmentId: widget.args.shiftAssignmentId, items: entries);
  }

  ShiftStockCountItemFormEntry _getOrCreateFormEntry(
    StockItemEntity item,
    double previousQty,
  ) {
    return _formEntries.putIfAbsent(
      item.id,
      () => ShiftStockCountItemFormEntry(
        stockItemId: item.id,
        itemName: item.name,
        unit: item.unit,
        initialQty: previousQty,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = context.color;
    final catalogAsync = ref.watch(itemCatalogProvider(true));
    final countsAsync = ref.watch(
      shiftStockCountsProvider(facilityId: widget.args.facilityId),
    );
    final isLoading = ref.watch(submitShiftStockCountProvider).isLoading;

    return Scaffold(
      backgroundColor: color.scaffoldBackground,
      appBar: AppBar(
        leading: const AppBackButton(),
        leadingWidth: AppBackButton.width,
        title: Headline2xlTinyText(context.locale.updateStock),
        centerTitle: true,
        backgroundColor: color.onPrimary,
        surfaceTintColor: Colors.transparent,
      ),
      body: catalogAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => AppErrorWidget(message: err.toString()),
        data: (catalog) => countsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => AppErrorWidget(message: err.toString()),
          data: (history) {
            final items = catalog.items;
            if (items.isEmpty) {
              return Center(
                child: Text(
                  context.locale.notAvailable,
                  style: context.textStyle.bodyMedium.copyWith(
                    color: color.text.secondary,
                  ),
                ),
              );
            }

            final latestByItem = {
              for (final count in latestStockCountPerItem(history))
                count.stockItemId: count.qtyOnHand,
            };

            return _UpdateStockBody(
              items: items,
              latestByItem: latestByItem,
              getOrCreateFormEntry: _getOrCreateFormEntry,
            );
          },
        ),
      ),
      bottomNavigationBar: _UpdateStockFooterBar(
        onSave: _onSave,
        isLoading: isLoading,
      ),
    );
  }
}
