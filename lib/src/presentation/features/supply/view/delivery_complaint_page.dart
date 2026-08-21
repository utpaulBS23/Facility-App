import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/app_permission.dart';
import '../../../../domain/entities/supply/delivery_entity.dart';
import '../../../../domain/entities/supply/supply_request_payloads.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/permission_gate.dart';
import '../../../core/widgets/text/typography.dart';
import '../riverpod/supply_request_action_provider.dart';

part '../widgets/additional_details_card.dart';
part '../widgets/delivery_complaint_body.dart';
part '../widgets/delivery_complaint_footer_bar.dart';
part '../widgets/discrepancy_summary_card.dart';
part '../widgets/proof_photo_picker_card.dart';

class DeliveryComplaintPage extends ConsumerStatefulWidget {
  const DeliveryComplaintPage({
    super.key,
    required this.delivery,
    required this.item,
  });

  final DeliveryEntity delivery;
  final DeliveryItemEntity item;

  @override
  ConsumerState<DeliveryComplaintPage> createState() =>
      _DeliveryComplaintPageState();
}

class _DeliveryComplaintPageState extends ConsumerState<DeliveryComplaintPage> {
  final _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  void _onFileStateChanged(
    AsyncValue<void>? previous,
    AsyncValue<void> next,
  ) {
    if (previous?.isLoading == true && next.hasValue && !next.hasError) {
      if (!mounted) return;
      AppSnackBar.showSuccess(
        context,
        context.locale.complaintSubmittedSuccessfully,
      );
      context.pop(true);
    } else if (next.hasError && mounted) {
      AppSnackBar.showError(context, context.locale.somethingWentWrong);
    }
  }

  void _onSubmitComplaint() {
    final request = FileDeliveryComplaintRequestEntity(
      deliveryId: widget.delivery.id,
      deliveryItemId: widget.item.id,
      reportedQtyReceived: widget.item.qtyReceived,
      reason: _reasonController.text.trim(),
      evidencePhotoUrl: '',
    );

    ref.read(supplyRequestActionProvider.notifier).fileDeliveryComplaint(request);
  }

  @override
  Widget build(BuildContext context) {
    final color = context.color;
    ref.listen(supplyRequestActionProvider, _onFileStateChanged);
    final actionState = ref.watch(supplyRequestActionProvider);
    final canSubmit =
        !actionState.isLoading && _reasonController.text.trim().isNotEmpty;

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
          isSubmitting: actionState.isLoading,
          canSubmit: canSubmit,
          onSubmit: _onSubmitComplaint,
          onCancel: () => context.pop(),
        ),
      ),
    );
  }
}
