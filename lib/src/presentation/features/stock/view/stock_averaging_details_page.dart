import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/app_permission.dart';
import '../../../../domain/entities/stock/facility_stock_target_entity.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/app_error_widget.dart';
import '../../../core/widgets/permission_gate.dart';
import '../../../core/widgets/text/typography.dart';
import '../riverpod/facility_stock_target_detail_provider.dart';

part '../widgets/average_demand_list_card.dart';
part '../widgets/facility_metadata_card.dart';
part '../widgets/monthly_total_summary_card.dart';

class StockAveragingDetailsPage extends ConsumerStatefulWidget {
  const StockAveragingDetailsPage({super.key, this.facilityId = 31});

  final int facilityId;

  @override
  ConsumerState<StockAveragingDetailsPage> createState() =>
      _StockAveragingDetailsPageState();
}

class _StockAveragingDetailsPageState
    extends ConsumerState<StockAveragingDetailsPage> {
  bool _isEditing = false;

  Future<void> _onSave() async {
    final notifier = ref.read(
      facilityStockTargetDetailNotifierProvider(widget.facilityId).notifier,
    );
    final success = await notifier.saveTargets();

    if (mounted) {
      if (success) {
        AppSnackBar.showSuccess(context, 'Stock targets saved successfully.');
        setState(() {
          _isEditing = false;
        });
      } else {
        AppSnackBar.showError(context, 'Failed to save stock targets.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;
    final detailAsync = ref.watch(
      facilityStockTargetDetailNotifierProvider(widget.facilityId),
    );

    return Scaffold(
      backgroundColor: color.scaffoldBackground,
      appBar: AppBar(
        leading: const AppBackButton(),
        leadingWidth: AppBackButton.width,
        title: Headline2xlTinyText(context.locale.updateStockTarget),
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
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => AppErrorWidget(
          message: err.toString(),
          onRetry: () => ref.invalidate(
            facilityStockTargetDetailNotifierProvider(widget.facilityId),
          ),
        ),
        data: (detail) {
          if (_isEditing) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(spacing.s16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _FacilityMetadataCard(
                    facilityName: detail.facilityName,
                    updatedByName: detail.targets.isNotEmpty
                        ? detail.targets.first.updatedByName
                        : '',
                    updatedAt: detail.targets.isNotEmpty
                        ? detail.targets.first.updatedAt
                        : '',
                  ),
                  Gap(spacing.s16),
                  _ItemStepperCardsSection(
                    targets: detail.targets,
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
                  Gap(spacing.s24),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(spacing.s16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _FacilityMetadataCard(
                  facilityName: detail.facilityName,
                  updatedByName: detail.targets.isNotEmpty
                      ? detail.targets.first.updatedByName
                      : '',
                  updatedAt: detail.targets.isNotEmpty
                      ? detail.targets.first.updatedAt
                      : '',
                ),
                Gap(spacing.s16),
                _MonthlyTotalSummaryCard(
                  targets: detail.targets,
                  monthlyTotalDemandQty: detail.monthlyTotalDemandQty,
                ),
                Gap(spacing.s24),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: _isEditing
          ? Padding(
              padding: EdgeInsets.all(spacing.s16),
              child: SizedBox(
                height: spacing.s44,
                child: FilledButton(
                  onPressed: detailAsync.isLoading ? null : _onSave,
                  child: const Text('Save Target'),
                ),
              ),
            )
          : null,
    );
  }
}
