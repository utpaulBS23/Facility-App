part of '../view/request_details_page.dart';

class _RequestDetailsBody extends StatelessWidget {
  const _RequestDetailsBody({
    required this.request,
    required this.deliveryAsync,
    required this.delivery,
    required this.editedQuantities,
    required this.onQuantityChanged,
    required this.onEditingCancelled,
    required this.onEvidenceReportTap,
    required this.onRetryDelivery,
  });

  final SupplyRequestEntity request;
  final AsyncValue<DeliveryEntity?> deliveryAsync;
  final DeliveryEntity? delivery;
  final Map<int, int> editedQuantities;
  final void Function(int stockItemId, int qty) onQuantityChanged;
  final VoidCallback onEditingCancelled;
  final void Function(ReceivedItemUiModel item) onEvidenceReportTap;
  final VoidCallback onRetryDelivery;

  Widget _buildReceivedItemsSection(BuildContext context) {
    if (!request.hasDelivery) {
      return _ReceivedItemsList(
        items: request.displayItems,
        priority: request.urgency,
        hasDelivery: false,
        isConfirmed: false,
        canEdit: false,
        editedQuantities: editedQuantities,
        onQuantityChanged: onQuantityChanged,
        onEditingCancelled: onEditingCancelled,
        onEvidenceReportTap: onEvidenceReportTap,
      );
    }

    return deliveryAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => AppErrorWidget(
        message: err.localizedMessage(context),
        onRetry: onRetryDelivery,
      ),
      data: (delivery) => _ReceivedItemsList(
        items: delivery?.displayItems ?? request.displayItems,
        priority: request.urgency,
        hasDelivery: true,
        isConfirmed: request.isDelivered,
        canEdit: request.status == SupplyRequestStatus.inDelivery,
        editedQuantities: editedQuantities,
        onQuantityChanged: onQuantityChanged,
        onEditingCancelled: onEditingCancelled,
        onEvidenceReportTap: onEvidenceReportTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        spacing.s16,
        spacing.s16,
        spacing.s16,
        request.hasBottomActionBar ? spacing.s180 : spacing.s24,
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
          _buildReceivedItemsSection(context),
          if (request.isDelivered && delivery?.receivedByName != null) ...[
            Gap(spacing.s12),
            _RequestUserCard(
              headerLabel: context.locale.receivedBy,
              userName: delivery!.receivedByName!,
              userRole: '',
              timestampLabel: context.locale.receivedOn(
                DateTime.tryParse(delivery!.confirmedAt ?? '') != null
                    ? DateFormatter.timestamp(
                        DateTime.parse(delivery!.confirmedAt!).toLocal(),
                      )
                    : (delivery!.confirmedAt ?? ''),
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
        ],
      ),
    );
  }
}
