part of '../view/request_details_page.dart';

class _RequestDetailsBody extends ConsumerWidget {
  const _RequestDetailsBody({
    required this.request,
    required this.lastAction,
    required this.editedQuantities,
    required this.onQuantityChanged,
    required this.onEditingCancelled,
    required this.onEvidenceReportTap,
    required this.onConfirmDeliveryTap,
    required this.onApprove,
    required this.onReject,
    required this.onDispatch,
    required this.onBack,
  });

  final SupplyRequestEntity request;
  final _DetailsAction? lastAction;
  final Map<int, int> editedQuantities;
  final void Function(int stockItemId, int qty) onQuantityChanged;
  final VoidCallback onEditingCancelled;
  final void Function(int stockItemId) onEvidenceReportTap;
  final void Function(SupplyRequestEntity request, DeliveryEntity delivery)
      onConfirmDeliveryTap;
  final VoidCallback onApprove;
  final VoidCallback onReject;
  final VoidCallback onDispatch;
  final VoidCallback onBack;

  Widget _buildReceivedItemsSection(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<DeliveryEntity?> deliveryAsync,
  ) {
    if (!request.hasDelivery) {
      return _ReceivedItemsList(
        requestItems: request.items,
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
        onRetry: () => ref.invalidate(
          supplyRequestDeliveryProvider(request.requestCode),
        ),
      ),
      data: (delivery) => _ReceivedItemsList(
        requestItems: request.items,
        deliveryItems: delivery?.items,
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
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = context.dimensions.spacing;
    final deliveryAsync = request.hasDelivery
        ? ref.watch(supplyRequestDeliveryProvider(request.requestCode))
        : const AsyncValue<DeliveryEntity?>.data(null);
    final delivery = deliveryAsync.valueOrNull;

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: AppBar(
        leading: AppBackButton(onTap: onBack),
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
            _buildReceivedItemsSection(context, ref, deliveryAsync),
            if (request.isDelivered && delivery != null) ...[
              Gap(spacing.s12),
              Builder(
                builder: (context) {
                  final d = delivery;
                  final rawName = d.receivedByName;
                  final confirmedAt = d.confirmedAt;
                  final formattedTime = DateTime.tryParse(confirmedAt) != null
                      ? DateFormatter.timestamp(
                          DateTime.parse(confirmedAt).toLocal(),
                        )
                      : confirmedAt;
                  return _RequestUserCard(
                    headerLabel: context.locale.receivedBy,
                    userName: rawName,
                    userRole: '',
                    timestampLabel: context.locale.receivedOn(formattedTime),
                  );
                },
              ),
            ],
            Gap(spacing.s12),
            RequestInfoCard(
              label: context.locale.notes,
              title: request.notes.isNotEmpty
                  ? request.notes
                  : context.locale.noNotesProvided,
            ),
          ],
        ),
      ),
      bottomNavigationBar: switch (request.status) {
        SupplyRequestStatus.pendingSupervisor ||
        SupplyRequestStatus.pendingOperationManager =>
          _PendingActionButtons(
            status: request.status,
            isApproveAction: lastAction == _DetailsAction.approve,
            onReject: onReject,
            onApprove: onApprove,
          ),
        SupplyRequestStatus.operationManagerApproved => _DispatchActionButton(
            onDispatch: onDispatch,
          ),
        SupplyRequestStatus.inDelivery => _RequestConfirmButton(
            delivery: delivery,
            onConfirmTap: () {
              if (delivery != null) {
                onConfirmDeliveryTap(request, delivery);
              }
            },
          ),
        _ => null,
      },
    );
  }
}
