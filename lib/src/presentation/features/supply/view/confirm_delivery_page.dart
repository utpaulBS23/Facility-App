import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/theme.dart';
import '../../../core/widgets/back_leading.dart';
import '../../../core/widgets/status_dot_tag.dart';
import '../../../core/widgets/text/typography.dart';
import '../widgets/stock_mock_models.dart';
import 'request_details_page.dart';

part '../widgets/confirm_delivery_footer_bar.dart';
part '../widgets/delivery_photo_card.dart';
part '../widgets/notes_input_card.dart';
part '../widgets/order_details_summary_card.dart';
part '../widgets/verify_items_card.dart';

class ConfirmDeliveryPage extends ConsumerStatefulWidget {
  const ConfirmDeliveryPage({super.key});

  @override
  ConsumerState<ConfirmDeliveryPage> createState() => _ConfirmDeliveryPageState();
}

class _ConfirmDeliveryPageState extends ConsumerState<ConfirmDeliveryPage> {
  final _notesController = TextEditingController();

  late List<VerifiableItem> _items;

  @override
  void initState() {
    super.initState();
    _items = [
      const VerifiableItem(
        name: 'Liquid Hand Soap',
        category: 'Consumables',
        quantity: 25,
        unit: 'Rolls',
        icon: Icons.water_drop_outlined,
        isVerified: true,
      ),
      const VerifiableItem(
        name: 'Paper Towel Pack',
        category: 'Accessories',
        quantity: 40,
        unit: 'Pieces',
        icon: Icons.cleaning_services_outlined,
        isVerified: true,
      ),
      const VerifiableItem(
        name: 'Jumbo Toilet Roll',
        category: 'Linens',
        quantity: 15,
        unit: 'Sets',
        icon: Icons.sanitizer_outlined,
        isVerified: false,
      ),
      const VerifiableItem(
        name: 'LED Desk Lamp',
        category: 'Electronics',
        quantity: 10,
        unit: 'Units',
        icon: Icons.lightbulb_outlined,
        isVerified: true,
      ),
    ];
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _onItemToggled(int index) {
    setState(() {
      _items[index] = _items[index].copyWith(
        isVerified: !_items[index].isVerified,
      );
    });
  }

  void _onToggleAll() {
    final allVerified = _items.every((i) => i.isVerified);
    setState(() {
      _items = _items.map((i) => i.copyWith(isVerified: !allVerified)).toList();
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
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Delivery receipt confirmed successfully')),
    );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;

    return Scaffold(
      backgroundColor: color.scaffoldBackground,
      appBar: AppBar(
        leading: const BackLeading(),
        leadingWidth: 100,
        title: const Headline2xlTinyText('Confirm Delivery'),
        centerTitle: true,
        backgroundColor: color.onPrimary,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(spacing.s16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const RequestInfoCard(
              label: 'Facility',
              title: 'Mirpur-10 Public Toilet Complex',
              subtitle: 'Mirpur-10, Dhaka',
              icon: Icons.location_on_outlined,
            ),
            Gap(spacing.s16),
            const _OrderDetailsSummaryCard(
              requestId: 'SR-1',
              requestedBy: 'Shafiqul Alam',
              urgency: 'Urgent',
            ),
            Gap(spacing.s16),
            _VerifyItemsCard(
              items: _items,
              onItemToggled: _onItemToggled,
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
      bottomNavigationBar: _ConfirmDeliveryFooterBar(
        onConfirm: _onConfirmReceipt,
        onCancel: () => context.pop(),
      ),
    );
  }
}
