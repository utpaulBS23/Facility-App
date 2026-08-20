import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/app_permission.dart';
import '../../../../domain/entities/supply/delivery_entity.dart';
import '../../../../domain/entities/supply/supply_request_entity.dart';
import '../../../../domain/entities/supply/supply_request_payloads.dart';
import '../../../../domain/entities/supply/supply_request_status.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/permission_gate.dart';
import '../../../core/widgets/status_dot_tag.dart';
import '../../../core/widgets/text/typography.dart';
import '../extensions/supply_status_extension.dart';
import '../riverpod/supply_request_action_provider.dart';
import '../widgets/item_stepper_input.dart';
import 'request_details_page.dart';

part '../widgets/confirm_delivery_body.dart';
part '../widgets/confirm_delivery_footer_bar.dart';
part '../widgets/delivery_photo_card.dart';
part '../widgets/notes_input_card.dart';
part '../widgets/order_details_summary_card.dart';
part '../widgets/verify_items_card.dart';

class ConfirmDeliveryPage extends ConsumerStatefulWidget {
  const ConfirmDeliveryPage({
    super.key,
    required this.request,
    required this.delivery,
  });

  final SupplyRequestEntity request;
  final DeliveryEntity delivery;

  @override
  ConsumerState<ConfirmDeliveryPage> createState() =>
      _ConfirmDeliveryPageState();
}

class _ConfirmDeliveryPageState extends ConsumerState<ConfirmDeliveryPage> {
  final _notesController = TextEditingController();

  late List<DeliveryItemEntity> _items;

  @override
  void initState() {
    super.initState();
    _items = List.from(widget.delivery.items);
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _onConfirmStateChanged(
    AsyncValue<void>? previous,
    AsyncValue<void> next,
  ) {
    if (previous?.isLoading == true && next.hasValue && !next.hasError) {
      if (!mounted) return;
      AppSnackBar.showSuccess(
        context,
        context.locale.confirmDeliveryReceipt,
      );
      context.goNamed(Routes.supplyRequests);
    } else if (next.hasError && mounted) {
      AppSnackBar.showError(context, context.locale.somethingWentWrong);
    }
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
        qtyReceived: quantity.toDouble(),
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
            qtyReceived: i.qtyReceived,
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

    ref.read(supplyRequestActionProvider.notifier).confirmDelivery(request);
  }

  @override
  Widget build(BuildContext context) {
    final color = context.color;
    ref.listen(supplyRequestActionProvider, _onConfirmStateChanged);
    final actionState = ref.watch(supplyRequestActionProvider);
    final hasAnyVerified = _items.any((item) => item.isVerified);

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
        request: widget.request,
        delivery: widget.delivery,
        items: _items,
        notesController: _notesController,
        onItemToggled: _onItemToggled,
        onQuantityChanged: _onQuantityChanged,
        onToggleAll: _onToggleAll,
      ),
      bottomNavigationBar: PermissionGate(
        permissions: const [UserPermission.deliveryConfirm],
        child: _ConfirmDeliveryFooterBar(
          isSubmitting: actionState.isLoading,
          isEnabled: hasAnyVerified,
          onConfirm: _onConfirmReceipt,
          onCancel: () => context.pop(),
        ),
      ),
    );
  }
}
