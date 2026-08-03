import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/app_permission.dart';
import '../../../../domain/entities/supply/delivery_entity.dart';
import '../../../../domain/entities/supply/supply_request_entity.dart';
import '../../../../domain/entities/supply/supply_request_status.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/permission_gate.dart';
import '../../../core/widgets/status_dot_tag.dart';
import '../../../core/widgets/text/typography.dart';
import '../extensions/supply_display_extensions.dart';
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
  bool _lastActionWasApprove = true;

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
        if (value == null || !mounted) {
          return;
        }

        final msg = _lastActionWasApprove
            ? context.locale.approved
            : context.locale.rejection;
        AppSnackBar.showSuccess(context, msg);
        context.pop();
      },
      error: (e, _) {
        if (!mounted) {
          return;
        }

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
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          spacing.s16,
          spacing.s16,
          spacing.s16,
          request.isApprovedStage ? spacing.s180 : spacing.s24,
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
              userRole: request.initiatedByRole.isNotEmpty
                  ? '${request.initiatedByRole[0].toUpperCase()}${request.initiatedByRole.substring(1)}'
                  : request.initiatedByRole,
              timestampLabel: context.locale.submittedOn(
                DateTime.tryParse(request.createdAt) != null
                    ? DateFormatter.timestamp(
                        DateTime.parse(request.createdAt).toLocal(),
                      )
                    : request.createdAt,
              ),
            ),
            Gap(spacing.s12),
            _ReceivedItemsList(
              items: delivery?.displayItems ?? request.displayItems,
              priority: request.urgency,
              isApprovedStage: request.isApprovedStage,
              isDelivered: request.isDelivered,
              canEdit: request.isDelivered ||
                  request.status == SupplyRequestStatus.pendingSupervisor,
              onEvidenceReportTap: (item) =>
                  _onEvidenceReportTap(context, item),
            ),
            if (request.isDelivered &&
                delivery?.receivedByName != null) ...[
              Gap(spacing.s12),
              _RequestUserCard(
                headerLabel: context.locale.receivedBy,
                userName: delivery!.receivedByName!,
                userRole: '',
                timestampLabel: context.locale.receivedOn(
                  DateTime.tryParse(delivery.confirmedAt ?? '') != null
                      ? DateFormatter.timestamp(
                          DateTime.parse(delivery.confirmedAt!).toLocal(),
                        )
                      : (delivery.confirmedAt ?? ''),
                ),
              ),
            ],
            Gap(spacing.s12),
            RequestInfoCard(
              label: context.locale.notes,
              title: (request.notes?.isNotEmpty ?? false)
                  ? request.notes!
                  : context.locale.noNotesProvided,
            ),
            if (request.isPendingStage) ...[
              PermissionGate(
                permissions: const [
                  UserPermission.supplyRequestApproveSupervisor,
                  UserPermission.supplyRequestApproveOperationManager,
                ],
                child: Padding(
                  padding: EdgeInsets.only(top: spacing.s16),
                  child: _PendingActionButtons(
                    isApproveAction: _lastActionWasApprove,
                    onReject: _onReject,
                    onApprove: _onApprove,
                  ),
                ),
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
