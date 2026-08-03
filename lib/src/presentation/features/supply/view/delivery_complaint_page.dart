import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/theme.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/text/typography.dart';
import 'request_details_page.dart';

part '../widgets/additional_details_card.dart';
part '../widgets/discrepancy_summary_card.dart';
part '../widgets/proof_photo_picker_card.dart';

class DeliveryComplaintPage extends ConsumerStatefulWidget {
  const DeliveryComplaintPage({super.key, this.item});

  final ReceivedItemUiModel? item;

  @override
  ConsumerState<DeliveryComplaintPage> createState() => _DeliveryComplaintPageState();
}

class _DeliveryComplaintPageState extends ConsumerState<DeliveryComplaintPage> {
  final _detailsController = TextEditingController();

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  void _onCameraTap() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Camera picker selected')),
    );
  }

  void _onGalleryTap() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Gallery picker selected')),
    );
  }

  void _onSubmitComplaint() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Complaint submitted successfully')),
    );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;

    final itemData = widget.item ??
        const ReceivedItemUiModel(
          name: 'Hand soap',
          code: 'ST-001',
          expectedQuantity: 25,
          receivedQuantity: 24,
          unit: 'rolls',
          icon: Icons.water_drop_outlined,
        );

    return Scaffold(
      backgroundColor: color.scaffoldBackground,
      appBar: AppBar(
        leading: const AppBackButton(),
        leadingWidth: AppBackButton.width,
        title: const Headline2xlTinyText('Delivery Complaint'),
        centerTitle: true,
        backgroundColor: color.onPrimary,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(spacing.s16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DiscrepancySummaryCard(item: itemData),
            Gap(spacing.s16),
            _ProofPhotoPickerCard(
              onCameraTap: _onCameraTap,
              onGalleryTap: _onGalleryTap,
            ),
            Gap(spacing.s16),
            _AdditionalDetailsCard(controller: _detailsController),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(spacing.s16),
        decoration: BoxDecoration(
          color: color.onPrimary,
          border: Border(top: BorderSide(color: color.borderSubtle)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                height: 44,
                child: FilledButton(
                  onPressed: _onSubmitComplaint,
                  child: const Text('Submit a complaint'),
                ),
              ),
              Gap(spacing.s12),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: OutlinedButton(
                  onPressed: () => context.pop(),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: color.borderSubtle),
                    foregroundColor: color.text.primary,
                  ),
                  child: const Text('Cancel'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
