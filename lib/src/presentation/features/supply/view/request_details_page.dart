import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../core/extensions/failure_localization.dart';
import '../../../../domain/entities/app_permission.dart';
import '../../../../domain/entities/supply/delivery_entity.dart';
import '../../../../domain/entities/supply/supply_request_entity.dart';
import '../../../../domain/entities/supply/supply_request_status.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/app_error_widget.dart';
import '../../../core/widgets/permission_gate.dart';
import '../../../core/widgets/status_dot_tag.dart';
import '../../../core/widgets/text/typography.dart';
import '../extensions/supply_display_extensions.dart';
import '../extensions/supply_status_extension.dart';
import '../riverpod/supply_request_action_provider.dart';
import '../riverpod/supply_request_delivery_provider.dart';
import '../riverpod/supply_request_details_provider.dart';
import '../widgets/item_stepper_input.dart';
import 'confirm_delivery_page.dart';
import '../models/received_item_ui_model.dart';

part '../widgets/pending_action_buttons.dart';
part '../widgets/received_item_card.dart';
part '../widgets/received_items_list.dart';
part '../widgets/request_details_body.dart';
part '../widgets/request_details_bottom_bar.dart';
part '../widgets/request_info_card.dart';
part '../widgets/request_status_timeline.dart';
part '../widgets/request_user_card.dart';

class RequestDetailsPage extends ConsumerStatefulWidget {
  const RequestDetailsPage({super.key, required this.request});

  final SupplyRequestEntity request;

  @override
  ConsumerState<RequestDetailsPage> createState() => _RequestDetailsPageState();
}

class _RequestDetailsPageState extends ConsumerState<RequestDetailsPage> {
  bool _lastActionWasApprove = true;
  final Map<int, int> _editedQuantities = {};

  @override
  void initState() {
    super.initState();
    ref.listenManual(supplyRequestActionProvider, _onActionStateChanged);
  }

  void _onActionStateChanged(
    AsyncValue<SupplyRequestEntity?>? previous,
    AsyncValue<SupplyRequestEntity?> next,
  ) {
    next.whenOrNull(
      data: (value) {
        if (value == null || !mounted) return;

        AppSnackBar.showSuccess(
          context,
          _lastActionWasApprove
              ? context.locale.approved
              : context.locale.rejection,
        );
        context.pop();
      },
      error: (e, _) {
        if (!mounted) return;

        AppSnackBar.showError(context, context.locale.somethingWentWrong);
      },
    );
  }

  void _onApprove() {
    _lastActionWasApprove = true;
    ref.read(supplyRequestActionProvider.notifier).approve(widget.request.id);
  }

  void _onReject() {
    _lastActionWasApprove = false;
    ref.read(supplyRequestActionProvider.notifier).reject(widget.request.id);
  }

  void _onEvidenceReportTap(ReceivedItemUiModel item) {
    context.pushNamed(Routes.deliveryComplaint, extra: item);
  }

  void _onQuantityChanged(int stockItemId, int qty) {
    setState(() => _editedQuantities[stockItemId] = qty);
  }

  void _onEditingCancelled() {
    setState(() => _editedQuantities.clear());
  }

  void _onConfirmDeliveryTap(SupplyRequestEntity request, DeliveryEntity delivery) {
    context.pushNamed(
      Routes.confirmDelivery,
      extra: ConfirmDeliveryPageArgs(
        delivery: delivery.withEditedQuantities(_editedQuantities),
        urgency: request.urgency,
        requestedByName: request.requestedByName,
      ),
    );
  }

  void _onBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.goNamed(Routes.shift);
    }
  }

  @override
  Widget build(BuildContext context) {
    final requestAsync = ref.watch(
      supplyRequestDetailsProvider(widget.request.id),
    );
    final request = requestAsync.valueOrNull ?? widget.request;

    final deliveryAsync = request.hasDelivery
        ? ref.watch(supplyRequestDeliveryProvider(request.requestCode))
        : const AsyncValue<DeliveryEntity?>.data(null);
    final delivery = deliveryAsync.valueOrNull;

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: AppBar(
        leading: AppBackButton(onTap: () => _onBack(context)),
        leadingWidth: AppBackButton.width,
        title: Headline2xlTinyText(context.locale.requestDetailsTitle),
        centerTitle: true,
        backgroundColor: context.color.onPrimary,
        surfaceTintColor: Colors.transparent,
      ),
      body: _RequestDetailsBody(
        request: request,
        deliveryAsync: deliveryAsync,
        delivery: delivery,
        editedQuantities: _editedQuantities,
        onQuantityChanged: _onQuantityChanged,
        onEditingCancelled: _onEditingCancelled,
        onEvidenceReportTap: _onEvidenceReportTap,
        onRetryDelivery: () =>
            ref.invalidate(supplyRequestDeliveryProvider(request.requestCode)),
        isApproveAction: _lastActionWasApprove,
        onApprove: _onApprove,
        onReject: _onReject,
      ),
      bottomNavigationBar: request.status == SupplyRequestStatus.inDelivery
          ? _RequestDetailsBottomBar(
              delivery: delivery,
              onConfirmTap: () => _onConfirmDeliveryTap(request, delivery!),
            )
          : null,
    );
  }
}
