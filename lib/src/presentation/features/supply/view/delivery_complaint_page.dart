import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/app_permission.dart';
import '../../../../domain/entities/supply/delivery_complaint_entity.dart';
import '../../../../domain/entities/supply/file_delivery_complaint_request.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/permission_gate.dart';
import '../../../core/widgets/text/typography.dart';
import '../models/received_item_ui_model.dart';
import '../riverpod/file_delivery_complaint_provider.dart';

part '../widgets/additional_details_card.dart';
part '../widgets/delivery_complaint_body.dart';
part '../widgets/delivery_complaint_footer_bar.dart';
part '../widgets/discrepancy_summary_card.dart';
part '../widgets/proof_photo_picker_card.dart';

class DeliveryComplaintPage extends ConsumerStatefulWidget {
  const DeliveryComplaintPage({super.key, required this.item});

  final ReceivedItemUiModel item;

  @override
  ConsumerState<DeliveryComplaintPage> createState() =>
      _DeliveryComplaintPageState();
}

class _DeliveryComplaintPageState extends ConsumerState<DeliveryComplaintPage> {
  final _reasonController = TextEditingController();

  @override
  void initState() {
    super.initState();
    ref.listenManual(fileDeliveryComplaintProvider, _onFileStateChanged);
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  void _onFileStateChanged(
    AsyncValue<DeliveryComplaintEntity?>? previous,
    AsyncValue<DeliveryComplaintEntity?> next,
  ) {
    next.whenOrNull(
      data: (value) {
        if (value == null || !mounted) return;

        AppSnackBar.showSuccess(
          context,
          context.locale.complaintSubmittedSuccessfully,
        );
        context.pop(value);
      },
      error: (e, _) {
        if (!mounted) return;

        AppSnackBar.showError(context, context.locale.somethingWentWrong);
      },
    );
  }

  void _onSubmitComplaint() {
    final deliveryId = widget.item.deliveryId;
    final deliveryItemId = widget.item.deliveryItemId;
    if (deliveryId == null || deliveryItemId == null) return;

    final request = FileDeliveryComplaintRequest(
      deliveryItemId: deliveryItemId,
      reportedQtyReceived: widget.item.receivedQuantity.toDouble(),
      reason: _reasonController.text.trim(),
    );

    ref.read(fileDeliveryComplaintProvider.notifier).file(
          deliveryId: deliveryId,
          request: request,
        );
  }

  @override
  Widget build(BuildContext context) {
    final color = context.color;
    final fileState = ref.watch(fileDeliveryComplaintProvider);
    final canSubmit =
        !fileState.isLoading && _reasonController.text.trim().isNotEmpty;

    return Scaffold(
      backgroundColor: color.scaffoldBackground,
      appBar: AppBar(
        leading: const AppBackButton(),
        leadingWidth: AppBackButton.width,
        title: Headline2xlTinyText(context.locale.deliveryComplaintTitle),
        centerTitle: true,
        backgroundColor: color.onPrimary,
        surfaceTintColor: Colors.transparent,
      ),
      body: _DeliveryComplaintBody(
        item: widget.item,
        reasonController: _reasonController,
        onReasonChanged: () => setState(() {}),
      ),
      bottomNavigationBar: PermissionGate(
        permissions: const [UserPermission.deliveryComplaintCreate],
        child: _DeliveryComplaintFooterBar(
          isSubmitting: fileState.isLoading,
          canSubmit: canSubmit,
          onSubmit: _onSubmitComplaint,
          onCancel: () => context.pop(),
        ),
      ),
    );
  }
}
