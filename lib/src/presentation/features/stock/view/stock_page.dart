import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/back_leading.dart';
import '../../../core/widgets/category_filter_chips.dart';
import '../../../core/widgets/status_dot_tag.dart';
import '../../../core/widgets/text/typography.dart';
import '../widgets/stock_mock_models.dart';

part '../widgets/stock_footer_bar.dart';
part '../widgets/stock_item_card.dart';
part '../widgets/stock_summary_row.dart';

class StockPage extends ConsumerStatefulWidget {
  const StockPage({super.key});

  @override
  ConsumerState<StockPage> createState() => _StockPageState();
}

class _StockPageState extends ConsumerState<StockPage> {
  String _selectedFilter = 'All';

  void _onUpdateStockBalances() {
    context.pushNamed(Routes.updateStock);
  }

  void _onItemTap(MockStockItem item) {
    context.pushNamed(Routes.updateStock);
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final color = context.color;

    final filteredItems = mockStockItems.where((item) {
      if (_selectedFilter == 'All') return true;
      return item.category.toLowerCase() == _selectedFilter.toLowerCase();
    }).toList();

    return Scaffold(
      backgroundColor: color.scaffoldBackground,
      appBar: AppBar(
        leading: const BackLeading(),
        leadingWidth: 100,
        title: const Headline2xlTinyText('Stock'),
        centerTitle: true,
        backgroundColor: color.onPrimary,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(spacing.s16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _StockSummaryRow(
              totalItems: 10,
              lowStockCount: 2,
              criticalCount: 2,
            ),
            Gap(spacing.s16),
            CategoryFilterChips(
              categories: const ['All', 'Consumables', 'Cleaning', 'Equipment'],
              selectedCategory: _selectedFilter,
              onSelected: (filter) => setState(() => _selectedFilter = filter),
            ),
            Gap(spacing.s16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredItems.length,
              separatorBuilder: (context, index) => Gap(spacing.s12),
              itemBuilder: (context, index) {
                final item = filteredItems[index];
                return _StockItemCard(
                  item: item,
                  onTap: () => _onItemTap(item),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: _StockFooterBar(
        onUpdateStockBalances: _onUpdateStockBalances,
      ),
    );
  }
}
