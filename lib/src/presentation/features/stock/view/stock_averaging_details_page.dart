import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../domain/entities/app_permission.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/app_error_widget.dart';
import '../../../core/widgets/permission_gate.dart';
import '../../../core/widgets/text/typography.dart';
import '../riverpod/facility_stock_target_detail_provider.dart';
import '../riverpod/update_stock_target_action_provider.dart';
import '../widgets/stock_target_detail_body.dart';
import '../widgets/stock_target_detail_shimmer.dart';

class StockAveragingDetailsPage extends ConsumerStatefulWidget {
  const StockAveragingDetailsPage({super.key, required this.facilityId});

  final int facilityId;

  @override
  ConsumerState<StockAveragingDetailsPage> createState() =>
      _StockAveragingDetailsPageState();
}

class _StockAveragingDetailsPageState
    extends ConsumerState<StockAveragingDetailsPage> {
  bool _isEditing = false;

  Future<void> _onSave() async {
    final detail = ref.read(
      facilityStockTargetDetailNotifierProvider(widget.facilityId),
    ).valueOrNull;

    if (detail == null) return;

    final success = await ref
        .read(updateStockTargetActionProvider.notifier)
        .saveTargets(
          facilityId: widget.facilityId,
          targets: detail.targets,
        );

    if (mounted) {
      if (success) {
        AppSnackBar.showSuccess(context, 'Stock targets saved successfully.');
        setState(() {
          _isEditing = false;
        });
      } else {
        final error = ref.read(updateStockTargetActionProvider).error;
        AppSnackBar.showError(
          context,
          error?.toString() ?? 'Failed to save stock targets.',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;
    final actionState = ref.watch(updateStockTargetActionProvider);
    final detailAsync = ref.watch(
      facilityStockTargetDetailNotifierProvider(widget.facilityId),
    );

    return Scaffold(
      backgroundColor: color.scaffoldBackground,
      appBar: AppBar(
        leading: AppBackButton(onTap: () => context.pop()),
        leadingWidth: AppBackButton.width,
        title: const Headline2xlTinyText('Stock Targets'),
        centerTitle: true,
        backgroundColor: color.onPrimary,
        surfaceTintColor: Colors.transparent,
        actions: [
          PermissionGate(
            permissions: const [UserPermission.facilityStockTargetUpdate],
            child: IconButton(
              icon: Icon(
                _isEditing ? Icons.close_rounded : Icons.edit_outlined,
                color: color.primary,
              ),
              onPressed: () {
                setState(() {
                  _isEditing = !_isEditing;
                });
              },
            ),
          ),
        ],
      ),
      body: detailAsync.when(
        loading: () => const StockTargetDetailShimmer(),
        error: (err, _) => AppErrorWidget(
          message: err.toString(),
          onRetry: () => ref.invalidate(
            facilityStockTargetDetailNotifierProvider(widget.facilityId),
          ),
        ),
        data: (detail) => StockTargetDetailBody(
          detail: detail,
          isEditing: _isEditing,
          onQtyChanged: (stockItemId, newQty) {
            ref
                .read(
                  facilityStockTargetDetailNotifierProvider(
                    widget.facilityId,
                  ).notifier,
                )
                .updateQty(stockItemId, newQty);
          },
        ),
      ),
      bottomNavigationBar: _isEditing
          ? Padding(
              padding: EdgeInsets.all(spacing.s16),
              child: SizedBox(
                height: spacing.s44,
                child: FilledButton(
                  onPressed: actionState.isLoading ? null : _onSave,
                  child: actionState.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Save Target'),
                ),
              ),
            )
          : null,
    );
  }
}
