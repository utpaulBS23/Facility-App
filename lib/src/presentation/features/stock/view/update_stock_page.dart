import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../core/extensions/failure_localization.dart';
import '../../../../core/base/base.dart';
import '../../../../domain/entities/stock/facility_stock_target_entity.dart';
import '../../../../domain/entities/stock/shift_stock_count_entity.dart';
import '../../../../domain/entities/stock/submit_stock_count_request.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/app_error_widget.dart';
import '../../../core/widgets/text/typography.dart';
import '../models/update_stock_page_args.dart';
import '../riverpod/facility_stock_targets_provider.dart';
import '../riverpod/shift_stock_counts_provider.dart';
import '../riverpod/submit_shift_stock_count_provider.dart';
import '../widgets/shimmer/shimmer_box.dart';

part '../widgets/instruction_alert_banner.dart';
part '../widgets/shimmer/update_stock_form_shimmer.dart';
part '../widgets/update_stock_footer_bar.dart';
part '../widgets/update_stock_form_card.dart';

class UpdateStockPage extends ConsumerStatefulWidget {
  const UpdateStockPage({super.key, required this.args});

  final UpdateStockPageArgs args;

  @override
  ConsumerState<UpdateStockPage> createState() => _UpdateStockPageState();
}

class _UpdateStockPageState extends ConsumerState<UpdateStockPage> {
  final Map<int, TextEditingController> _controllers = {};
  bool _controllersReady = false;
  ProviderSubscription<AsyncValue<List<ShiftStockCountEntity>?>>?
  _submitSubscription;

  @override
  void initState() {
    super.initState();
    _submitSubscription = ref.listenManual(
      submitShiftStockCountProvider,
      _onSubmitStateChanged,
    );
  }

  @override
  void dispose() {
    _submitSubscription?.close();
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onSubmitStateChanged(
    AsyncValue<List<ShiftStockCountEntity>?>? previous,
    AsyncValue<List<ShiftStockCountEntity>?> next,
  ) {
    next.when(
      data: (data) {
        if (data == null) return;
        AppSnackBar.showSuccess(
          context,
          context.locale.stockBalancesSavedSuccessfully,
        );
        context.pop();
      },
      error: (error, _) {
        if (error is Failure) {
          AppSnackBar.showError(context, error.localizedMessage(context));
        }
      },
      loading: () {},
    );
  }

  void _ensureControllers(
    List<FacilityStockTargetEntity> targets,
    List<ShiftStockCountEntity> counts,
  ) {
    if (_controllersReady) return;

    final latestByItem = <int, ShiftStockCountEntity>{};
    for (final count in counts) {
      final existing = latestByItem[count.stockItemId];
      if (existing == null) {
        latestByItem[count.stockItemId] = count;
        continue;
      }
      final existingAt = existing.reportedAt;
      final currentAt = count.reportedAt;
      if (currentAt != null &&
          (existingAt == null ||
              DateTime.parse(currentAt).isAfter(DateTime.parse(existingAt)))) {
        latestByItem[count.stockItemId] = count;
      }
    }

    for (final target in targets) {
      final previousQty = latestByItem[target.stockItemId]?.qtyOnHand ?? 0;
      _controllers[target.stockItemId] = TextEditingController(
        text: previousQty.toStringAsFixed(0),
      );
    }

    _controllersReady = true;
  }

  void _onSave() {
    final items = [
      for (final entry in _controllers.entries)
        StockCountItemInput(
          stockItemId: entry.key,
          qtyOnHand: double.tryParse(entry.value.text) ?? 0,
        ),
    ];

    ref
        .read(submitShiftStockCountProvider.notifier)
        .submit(
          shiftAssignmentId: widget.args.shiftAssignmentId,
          request: SubmitStockCountRequest(items: items),
        );
  }

  @override
  Widget build(BuildContext context) {
    final color = context.color;
    final targetsAsync = ref.watch(
      facilityStockTargetsProvider(widget.args.facilityId),
    );
    final countsAsync = ref.watch(
      shiftStockCountsProvider(widget.args.facilityId),
    );

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
      body: targetsAsync.when(
        loading: () => const _UpdateStockFormShimmer(),
        error: (err, _) => AppErrorWidget(message: err.toString()),
        data: (targets) => countsAsync.when(
          loading: () => const _UpdateStockFormShimmer(),
          error: (err, _) => AppErrorWidget(message: err.toString()),
          data: (counts) {
            _ensureControllers(targets, counts);

            return _UpdateStockBody(
              targets: targets,
              controllers: _controllers,
            );
          },
        ),
      ),
      bottomNavigationBar: _UpdateStockFooterBar(onSave: _onSave),
    );
  }
}
