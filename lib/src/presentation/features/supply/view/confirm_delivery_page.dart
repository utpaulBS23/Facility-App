import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/app_permission.dart';
import '../../../../domain/entities/supply/confirm_delivery_request.dart';
import '../../../../domain/entities/supply/delivery_entity.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/permission_gate.dart';
import '../../../core/widgets/status_dot_tag.dart';
import '../../../core/widgets/text/typography.dart';
import '../riverpod/confirm_delivery_provider.dart';
import '../widgets/item_stepper_input.dart';
import 'request_details_page.dart';

part '../widgets/confirm_delivery_footer_bar.dart';
part '../widgets/delivery_photo_card.dart';
part '../widgets/notes_input_card.dart';
part '../widgets/order_details_summary_card.dart';
part '../widgets/verify_items_card.dart';

class ConfirmDeliveryItemUiState {
  const ConfirmDeliveryItemUiState({
    required this.stockItemId,
    required this.itemName,
    required this.category,
    required this.qtyExpected,
    required this.qtyReceived,
    required this.unit,
    this.isVerified = true,
  });

  final int stockItemId;
  final String itemName;
  final String category;
  final int qtyExpected;
  final int qtyReceived;
  final String unit;
  final bool isVerified;

  factory ConfirmDeliveryItemUiState.fromEntity(DeliveryItemEntity entity) {
    return ConfirmDeliveryItemUiState(
      stockItemId: entity.stockItemId,
      itemName: entity.itemName,
      category: entity.unit,
      qtyExpected: entity.qtyExpected.round(),
      qtyReceived: entity.qtyReceived > 0
          ? entity.qtyReceived.round()
          : entity.qtyExpected.round(),
      unit: entity.unit,
      isVerified: entity.isVerified,
    );
  }

  ConfirmDeliveryItemUiState copyWith({
    int? qtyReceived,
    bool? isVerified,
  }) {
    return ConfirmDeliveryItemUiState(
      stockItemId: stockItemId,
      itemName: itemName,
      category: category,
      qtyExpected: qtyExpected,
      qtyReceived: qtyReceived ?? this.qtyReceived,
      unit: unit,
      isVerified: isVerified ?? this.isVerified,
    );
  }
}

class ConfirmDeliveryPage extends ConsumerStatefulWidget {
  const ConfirmDeliveryPage({
    super.key,
    this.delivery,
  });

  final DeliveryEntity? delivery;

  @override
  ConsumerState<ConfirmDeliveryPage> createState() =>
      _ConfirmDeliveryPageState();
}

class _ConfirmDeliveryPageState extends ConsumerState<ConfirmDeliveryPage> {
  final _notesController = TextEditingController();

  late List<ConfirmDeliveryItemUiState> _items;

  @override
  void initState() {
    super.initState();
    ref.listenManual(confirmDeliveryProvider, _onConfirmStateChanged);

    final deliveryItems = widget.delivery?.items;
    if (deliveryItems != null && deliveryItems.isNotEmpty) {
      _items = deliveryItems
          .map((i) => ConfirmDeliveryItemUiState.fromEntity(i))
          .toList();
    } else {
      _items = const [];
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _onConfirmStateChanged(
    AsyncValue<DeliveryEntity?>? previous,
    AsyncValue<DeliveryEntity?> next,
  ) {
    next.whenOrNull(
      data: (value) {
        if (value == null || !mounted) return;
        AppSnackBar.showSuccess(
          context,
          context.locale.confirmDeliveryReceipt,
        );
        context.pop(value);
      },
      error: (e, _) {
        if (!mounted) return;
        AppSnackBar.showError(context, context.locale.somethingWentWrong);
      },
    );
  }

  void _onItemToggled(int index) {
    setState(() {
      _items[index] = _items[index].copyWith(
        isVerified: !_items[index].isVerified,
      );
    });
  }

  void _onQuantityChanged(int index, int quantity) {
    setState(() {
      _items[index] = _items[index].copyWith(
        qtyReceived: quantity,
      );
    });
  }

  void _onToggleAll() {
    final allVerified = _items.every((i) => i.isVerified);
    setState(() {
      _items =
          _items.map((i) => i.copyWith(isVerified: !allVerified)).toList();
    });
  }

  void _onCameraTap() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Camera option selected')),
    );
  }

  void _onGalleryTap() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Gallery option selected')),
    );
  }

  void _onConfirmReceipt() {
    final deliveryId = widget.delivery?.id;
    if (deliveryId == null) return;

    final requestItems = _items
        .map(
          (i) => ConfirmDeliveryItem(
            stockItemId: i.stockItemId,
            qtyReceived: i.qtyReceived.toDouble(),
            isVerified: i.isVerified,
          ),
        )
        .toList();

    final request = ConfirmDeliveryRequest(
      items: requestItems,
      deliveryNotes: _notesController.text.trim(),
    );

    ref.read(confirmDeliveryProvider.notifier).confirm(
          deliveryId: deliveryId,
          request: request,
        );
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;
    final confirmState = ref.watch(confirmDeliveryProvider);

    final facilityName =
        widget.delivery?.facilityName ?? 'Mirpur-10 Public Toilet Complex';
    final requestCode = widget.delivery?.requestCode ?? 'SR-1';
    final receivedByName = widget.delivery?.receivedByName ?? 'Shafiqul Alam';

    return Scaffold(
      backgroundColor: color.scaffoldBackground,
      appBar: AppBar(
        leading: const AppBackButton(),
        leadingWidth: AppBackButton.width,
        title: Headline2xlTinyText(context.locale.confirmDeliveryReceipt),
        centerTitle: true,
        backgroundColor: color.onPrimary,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(spacing.s16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            RequestInfoCard(
              label: 'Facility',
              title: facilityName,
              subtitle: 'Mirpur-10, Dhaka',
              icon: Icons.location_on_outlined,
            ),
            Gap(spacing.s16),
            _OrderDetailsSummaryCard(
              requestId: requestCode,
              requestedBy: receivedByName,
              urgency: 'Normal',
            ),
            Gap(spacing.s16),
            _VerifyItemsCard(
              items: _items,
              onItemToggled: _onItemToggled,
              onQuantityChanged: _onQuantityChanged,
              onToggleAll: _onToggleAll,
            ),
            Gap(spacing.s16),
            _NotesInputCard(controller: _notesController),
            Gap(spacing.s16),
            _DeliveryPhotoCard(
              onCameraTap: _onCameraTap,
              onGalleryTap: _onGalleryTap,
            ),
            Gap(spacing.s24),
          ],
        ),
      ),
      bottomNavigationBar: PermissionGate(
        permissions: const [UserPermission.deliveryConfirm],
        child: _ConfirmDeliveryFooterBar(
          isSubmitting: confirmState.isLoading,
          onConfirm: _onConfirmReceipt,
          onCancel: () => context.pop(),
        ),
      ),
    );
  }
}
