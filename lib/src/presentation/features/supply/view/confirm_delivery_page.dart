import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/app_permission.dart';
import '../../../../domain/entities/supply/delivery_entity.dart';
import '../../../../domain/entities/supply/supply_request_payloads.dart';
import '../../../../domain/entities/supply/supply_request_status.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/permission_gate.dart';
import '../../../core/widgets/status_dot_tag.dart';
import '../../../core/widgets/text/typography.dart';
import '../extensions/supply_status_extension.dart';
import '../riverpod/confirm_delivery_provider.dart';
import '../widgets/item_stepper_input.dart';
import '../models/confirm_delivery_item_ui_state.dart';
import 'request_details_page.dart';

export '../models/confirm_delivery_page_args.dart';

part '../widgets/confirm_delivery_body.dart';
part '../widgets/confirm_delivery_footer_bar.dart';
part '../widgets/delivery_photo_card.dart';
part '../widgets/notes_input_card.dart';
part '../widgets/order_details_summary_card.dart';
part '../widgets/verify_items_card.dart';

class ConfirmDeliveryPage extends ConsumerStatefulWidget {
  const ConfirmDeliveryPage({
    super.key,
    required this.delivery,
    required this.urgency,
    required this.requestedByName,
  });

  final DeliveryEntity delivery;
  final SupplyUrgency urgency;
  final String requestedByName;

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

    _items = widget.delivery.items
        .map((i) => ConfirmDeliveryItemUiState.fromEntity(i))
        .toList();
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

  void _onConfirmReceipt() {
    final requestItems = _items
        .map(
          (i) => ConfirmDeliveryItem(
            stockItemId: i.stockItemId,
            qtyReceived: i.qtyReceived.toDouble(),
            isVerified: i.isVerified,
          ),
        )
        .toList();

    final request = ConfirmDeliveryRequestEntity(
      deliveryId: widget.delivery.id,
      items: requestItems,
      receiptPhotoUrl: '',
      deliveryNotes: _notesController.text.trim(),
    );

    ref.read(confirmDeliveryProvider.notifier).confirm(request);
  }

  @override
  Widget build(BuildContext context) {
    final color = context.color;
    final confirmState = ref.watch(confirmDeliveryProvider);

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
      body: _ConfirmDeliveryBody(
        delivery: widget.delivery,
        urgency: widget.urgency,
        requestedByName: widget.requestedByName,
        items: _items,
        notesController: _notesController,
        onItemToggled: _onItemToggled,
        onQuantityChanged: _onQuantityChanged,
        onToggleAll: _onToggleAll,
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
