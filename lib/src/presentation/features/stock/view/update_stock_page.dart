import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/theme.dart';
import '../../../core/widgets/back_leading.dart';
import '../../../core/widgets/text/typography.dart';
import '../widgets/stock_mock_models.dart';

part '../widgets/instruction_alert_banner.dart';
part '../widgets/update_stock_footer_bar.dart';
part '../widgets/update_stock_form_card.dart';

class UpdateStockPage extends ConsumerStatefulWidget {
  const UpdateStockPage({super.key});

  @override
  ConsumerState<UpdateStockPage> createState() => _UpdateStockPageState();
}

class _UpdateStockPageState extends ConsumerState<UpdateStockPage> {
  final Map<int, TextEditingController> _balControllers = {};
  final Map<int, TextEditingController> _notesControllers = {};

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < mockStockItems.length; i++) {
      _balControllers[i] = TextEditingController(
        text: '${mockStockItems[i].quantity}',
      );
      _notesControllers[i] = TextEditingController();
    }
  }

  @override
  void dispose() {
    for (final controller in _balControllers.values) {
      controller.dispose();
    }
    for (final controller in _notesControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onSave() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Stock balances saved successfully')),
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
        title: const Headline2xlTinyText('Update Stock'),
        centerTitle: true,
        backgroundColor: color.onPrimary,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(spacing.s16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _InstructionAlertBanner(),
            Gap(spacing.s16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: mockStockItems.length,
              separatorBuilder: (context, index) => Gap(spacing.s12),
              itemBuilder: (context, index) {
                final item = mockStockItems[index];
                return _UpdateStockFormCard(
                  item: item,
                  currentBalController: _balControllers[index]!,
                  notesController: _notesControllers[index]!,
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: _UpdateStockFooterBar(onSave: _onSave),
    );
  }
}
