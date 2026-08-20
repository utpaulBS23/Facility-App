import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../core/extensions/failure_localization.dart';
import '../../../../domain/entities/app_permission.dart';
import '../../../../domain/entities/supply/delivery_entity.dart';
import '../../../../domain/entities/supply/supply_approval_enums.dart';
import '../../../../domain/entities/supply/supply_request_entity.dart';
import '../../../../domain/entities/supply/supply_request_status.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/utils/number_formatter.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/app_error_widget.dart';
import '../../../core/widgets/permission_gate.dart';
import '../../../core/widgets/status_dot_tag.dart';
import '../../../core/widgets/text/typography.dart';
import '../riverpod/supply_request_action_provider.dart';
import '../riverpod/supply_request_delivery_provider.dart';
import '../riverpod/supply_request_details_provider.dart';
import '../widgets/item_stepper_input.dart';
import 'confirm_delivery_page.dart';

part '../widgets/dispatch_action_button.dart';
part '../widgets/pending_action_buttons.dart';
part '../widgets/received_item_card.dart';
part '../widgets/received_items_list.dart';
part '../widgets/received_items_section.dart';
part '../widgets/request_confirm_button.dart';
part '../widgets/request_details_body.dart';
part '../widgets/request_details_error.dart';
part '../widgets/request_details_loading.dart';
part '../widgets/request_info_card.dart';
part '../widgets/request_status_timeline.dart';
part '../widgets/request_user_card.dart';
part '../widgets/timeline_circle_node.dart';
part '../widgets/timeline_labels_row.dart';
part '../widgets/timeline_nodes_row.dart';

class RequestDetailsPage extends ConsumerStatefulWidget {
  const RequestDetailsPage({super.key, required this.requestId});

  final int requestId;

  @override
  ConsumerState<RequestDetailsPage> createState() => _RequestDetailsPageState();
}

enum _DetailsAction { approve, reject, dispatch }

class _RequestDetailsPageState extends ConsumerState<RequestDetailsPage> {
  _DetailsAction? _lastAction;
  final Map<int, int> _editedQuantities = {};

  @override
  void initState() {
    super.initState();
    ref.listenManual(supplyRequestActionProvider, _onActionStateChanged);
  }

  void _onActionStateChanged(
    AsyncValue<void>? previous,
    AsyncValue<void> next,
  ) {
    if (previous?.isLoading == true && next.hasValue && !next.hasError) {
      if (!mounted || _lastAction == null) return;

      final message = switch (_lastAction!) {
        _DetailsAction.approve => context.locale.approved,
        _DetailsAction.reject => context.locale.rejection,
        _DetailsAction.dispatch => context.locale.dispatchSuccess,
      };

      AppSnackBar.showSuccess(context, message);
      context.pop();
    } else if (next.hasError) {
      if (!mounted) return;
      AppSnackBar.showError(context, context.locale.somethingWentWrong);
    }
  }

  void _onDispatch() {
    _lastAction = _DetailsAction.dispatch;
    ref.read(supplyRequestActionProvider.notifier).dispatch(widget.requestId);
  }

  void _onApprove() {
    _lastAction = _DetailsAction.approve;
    ref.read(supplyRequestActionProvider.notifier).approve(widget.requestId);
  }

  void _onReject() {
    _lastAction = _DetailsAction.reject;
    ref.read(supplyRequestActionProvider.notifier).reject(widget.requestId);
  }

  void _onEvidenceReportTap(int stockItemId) {
    // Delivery complaint route exists on feature/supply-confirm-delivery branch
  }

  void _onQuantityChanged(int stockItemId, int qty) {
    setState(() => _editedQuantities[stockItemId] = qty);
  }

  void _onEditingCancelled() {
    setState(() => _editedQuantities.clear());
  }

  void _onConfirmDeliveryTap(
    SupplyRequestEntity request,
    DeliveryEntity delivery,
  ) {
    final updatedItems = delivery.items.map((item) {
      final editedQty = _editedQuantities[item.stockItemId];
      if (editedQty == null) return item;
      return item.copyWith(qtyReceived: editedQty.toDouble());
    }).toList();

    final updatedDelivery = delivery.copyWith(items: updatedItems);

    context.pushNamed(
      Routes.confirmDelivery,
      extra: ConfirmDeliveryPageArgs(
        delivery: updatedDelivery,
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
      supplyRequestDetailsProvider(widget.requestId),
    );

    return switch (requestAsync) {
      AsyncData(value: final request) => _RequestDetailsBody(
          request: request,
          lastAction: _lastAction,
          editedQuantities: _editedQuantities,
          onQuantityChanged: _onQuantityChanged,
          onEditingCancelled: _onEditingCancelled,
          onEvidenceReportTap: _onEvidenceReportTap,
          onConfirmDeliveryTap: _onConfirmDeliveryTap,
          onApprove: _onApprove,
          onReject: _onReject,
          onDispatch: _onDispatch,
          onBack: () => _onBack(context),
        ),
      AsyncError(:final error) => _RequestDetailsError(
          error: error,
          onRetry: () => ref.invalidate(
            supplyRequestDetailsProvider(widget.requestId),
          ),
          onBack: () => _onBack(context),
        ),
      _ => _RequestDetailsLoading(
          onBack: () => _onBack(context),
        ),
    };
  }
}
