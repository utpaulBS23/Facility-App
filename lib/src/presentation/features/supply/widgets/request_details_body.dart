part of '../view/request_details_page.dart';

class _RequestDetailsBody extends ConsumerWidget {
  const _RequestDetailsBody({
    required this.request,
    required this.lastAction,
    required this.isEditing,
    required this.onEditToggled,
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
  final bool isEditing;
  final ValueChanged<bool> onEditToggled;

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

  String _formatDate(String rawDate) {
    final parsed = DateTime.tryParse(rawDate);
    if (parsed == null) return rawDate;
    return DateFormatter.timestamp(parsed.toLocal());
  }

  String _capitalizeRole(String role) {
    if (role.isEmpty) return role;
    return '${role[0].toUpperCase()}${role.substring(1)}';
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
              userRole: _capitalizeRole(request.initiatedByRole),
              timestampLabel: context.locale.submittedOn(
                _formatDate(request.createdAt),
              ),
            ),
            Gap(spacing.s12),
            _ReceivedItemsSection(
              request: request,
              isEditing: isEditing,
              onEditToggled: onEditToggled,
              editedQuantities: editedQuantities,
              onQuantityChanged: onQuantityChanged,
              onEditingCancelled: onEditingCancelled,
              onEvidenceReportTap: onEvidenceReportTap,
            ),
            if (request.isDelivered && delivery != null) ...[
              Gap(spacing.s12),
              _RequestUserCard(
                headerLabel: context.locale.receivedBy,
                userName: delivery.receivedByName,
                userRole: '',
                timestampLabel: context.locale.receivedOn(
                  _formatDate(delivery.confirmedAt),
                ),
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
            isEnabled: !isEditing,
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
