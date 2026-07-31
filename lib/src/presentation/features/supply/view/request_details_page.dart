import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/app_permission.dart';
import '../../../../domain/entities/supply/delivery_entity.dart';
import '../../../../domain/entities/supply/supply_request_entity.dart';
import '../../../../domain/entities/supply/supply_request_status.dart';
import '../../../core/application_state/session_provider/session_provider.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/back_leading.dart';
import '../../../core/widgets/status_dot_tag.dart';
import '../../../core/widgets/text/typography.dart';
import '../extensions/supply_status_extension.dart';
import '../riverpod/supply_request_action_provider.dart';
import '../riverpod/supply_request_delivery_provider.dart';
import '../riverpod/supply_request_details_provider.dart';
import '../widgets/item_stepper_input.dart';
import '../widgets/stock_mock_models.dart';

part '../widgets/new_item_entry_card.dart';
part '../widgets/pending_action_buttons.dart';
part '../widgets/received_item_card.dart';
part '../widgets/received_items_list.dart';
part '../widgets/request_info_card.dart';
part '../widgets/request_status_timeline.dart';
part '../widgets/request_user_card.dart';

class RequestDetailsPage extends ConsumerStatefulWidget {
  const RequestDetailsPage({super.key, required this.request});

  final SupplyRequestEntity request;

  @override
  ConsumerState<RequestDetailsPage> createState() =>
      _RequestDetailsPageState();
}

class _RequestDetailsPageState extends ConsumerState<RequestDetailsPage> {
  ProviderSubscription<AsyncValue>? _actionSub;
  bool _isApproving = false;
  bool _isRejecting = false;
  bool _lastActionWasApprove = true;

  @override
  void initState() {
    super.initState();
    _actionSub = ref.listenManual(supplyRequestActionProvider, (_, next) {
      next.whenOrNull(
        data: (value) {
          if (value == null || !mounted) return;
          final msg = _lastActionWasApprove
              ? context.locale.approved
              : context.locale.rejection;
          AppSnackBar.showSuccess(context, msg);
          context.pop();
        },
        error: (e, _) {
          if (!mounted) return;
          AppSnackBar.showError(context, context.locale.somethingWentWrong);
        },
      );
    });
  }

  @override
  void dispose() {
    _actionSub?.close();
    super.dispose();
  }

  void _onApprove() async {
    if (_isApproving || _isRejecting) return;
    setState(() => _isApproving = true);
    _lastActionWasApprove = true;

    await ref
        .read(supplyRequestActionProvider.notifier)
        .approve(widget.request.id);

    if (mounted) setState(() => _isApproving = false);
  }

  void _onReject() async {
    if (_isApproving || _isRejecting) return;
    setState(() => _isRejecting = true);
    _lastActionWasApprove = false;

    await ref
        .read(supplyRequestActionProvider.notifier)
        .reject(widget.request.id);

    if (mounted) setState(() => _isRejecting = false);
  }

  void _onEvidenceReportTap(BuildContext context, MockReceivedItem item) {
    context.pushNamed(Routes.deliveryComplaint, extra: item);
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
    final requestAsync =
        ref.watch(supplyRequestDetailsProvider(widget.request.id));
    final request = requestAsync.valueOrNull ?? widget.request;
    final spacing = context.dimensions.spacing;

    final isApprovedStage =
        request.status == SupplyRequestStatus.operationManagerApproved ||
            request.status == SupplyRequestStatus.inDelivery ||
            request.status == SupplyRequestStatus.delivered;
    final isDelivered = request.status == SupplyRequestStatus.delivered;

    final hasDelivery = request.status == SupplyRequestStatus.inDelivery ||
        request.status == SupplyRequestStatus.delivered;
    final deliveryAsync = hasDelivery
        ? ref.watch(supplyRequestDeliveryProvider(request.requestCode))
        : const AsyncValue<DeliveryEntity?>.data(null);
    final delivery = deliveryAsync.valueOrNull;

    final canApproveOrReject = ref.watch(
      userSessionProvider.select(
        (session) =>
            (session?.can(UserPermission.supplyRequestApproveSupervisor) ??
                false) ||
            (session?.can(
                  UserPermission.supplyRequestApproveOperationManager,
                ) ??
                false),
      ),
    );
    final isActionable = canApproveOrReject &&
        (request.status == SupplyRequestStatus.pendingSupervisor ||
            request.status == SupplyRequestStatus.pendingOperationManager);

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: AppBar(
        leading: BackLeading(onTap: () => _onBack(context)),
        leadingWidth: spacing.s100,
        title: Headline2xlTinyText(context.locale.requestDetailsTitle),
        centerTitle: true,
        backgroundColor: context.color.onPrimary,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          spacing.s16,
          spacing.s16,
          spacing.s16,
          isApprovedStage ? 160 : spacing.s24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _RequestStatusTimeline(request: request),
            Gap(spacing.s24),
            RequestInfoCard(
              label: context.locale.facility,
              title: request.facilityName,
            ),
            Gap(spacing.s12),
            _RequestUserCard(
              headerLabel: context.locale.requestedByLabel,
              userName: request.requestedByName,
              userRole: _capitalizeRole(request.initiatedByRole),
              timestampLabel: context.locale
                  .submittedOn(_formatDateTime(request.createdAt)),
            ),
            Gap(spacing.s12),
            _ReceivedItemsList(
              items: delivery != null
                  ? _itemsFromDelivery(delivery)
                  : _itemsForDisplay(request),
              priority: request.urgency,
              isApprovedStage: isApprovedStage,
              isDelivered: isDelivered,
              canEdit: isDelivered ||
                  request.status == SupplyRequestStatus.pendingSupervisor,
              onEvidenceReportTap: (item) =>
                  _onEvidenceReportTap(context, item),
            ),
            if (request.status == SupplyRequestStatus.delivered &&
                delivery?.receivedByName != null) ...[
              Gap(spacing.s12),
              _RequestUserCard(
                headerLabel: context.locale.receivedBy,
                userName: delivery!.receivedByName!,
                userRole: '',
                timestampLabel: context.locale
                    .receivedOn(_formatDateTime(delivery.confirmedAt ?? '')),
              ),
            ],
            Gap(spacing.s12),
            RequestInfoCard(
              label: context.locale.notes,
              title: (request.notes?.isNotEmpty ?? false)
                  ? request.notes!
                  : context.locale.noNotesProvided,
            ),
            if (isActionable) ...[
              Gap(spacing.s16),
              _PendingActionButtons(
                isApproving: _isApproving,
                isRejecting: _isRejecting,
                onReject: _onReject,
                onApprove: _onApprove,
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: request.status == SupplyRequestStatus.delivered
          ? Container(
              padding: EdgeInsets.all(spacing.s16),
              decoration: BoxDecoration(
                color: context.color.onPrimary,
                border:
                    Border(top: BorderSide(color: context.color.borderSubtle)),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: spacing.s44,
                      child: FilledButton(
                        // Confirm-receipt flow gets its own page in a later branch.
                        onPressed: null,
                        child: Text(context.locale.confirmDeliveryReceipt),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }
}

String _capitalizeRole(String role) =>
    role.isEmpty ? role : '${role[0].toUpperCase()}${role.substring(1)}';

String _formatDateTime(String iso) {
  if (iso.isEmpty) return iso;
  try {
    return DateFormatter.timestamp(DateTime.parse(iso).toLocal());
  } catch (_) {
    return iso;
  }
}

List<MockReceivedItem> _itemsFromDelivery(DeliveryEntity delivery) {
  return delivery.items.map((item) {
    return MockReceivedItem(
      name: item.itemName,
      code: item.itemCode,
      expectedQuantity: item.qtyExpected.round(),
      receivedQuantity: item.qtyReceived.round(),
      unit: item.unit,
      icon: Icons.inventory_2_outlined,
    );
  }).toList();
}

List<MockReceivedItem> _itemsForDisplay(SupplyRequestEntity request) {
  return request.items.map((item) {
    final qty = item.qtyRequested.round();
    return MockReceivedItem(
      name: item.itemName,
      code: item.itemCode,
      expectedQuantity: qty,
      receivedQuantity: qty,
      unit: item.unit,
      icon: Icons.inventory_2_outlined,
    );
  }).toList();
}
