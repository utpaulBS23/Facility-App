import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../core/extensions/failure_localization.dart';
import '../../../../domain/entities/toilet_location/toilet_entity.dart';
import '../../../../domain/entities/toilet_location/toilet_filter.dart';
import '../../../../domain/entities/toilet_location/toilet_list_page_entity.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/number_formatter.dart';
import '../../../core/widgets/app_error_widget.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/category_filter_chips.dart';
import '../../../core/widgets/detail_app_bar.dart';
import '../extensions/toilet_direction_extension.dart';
import '../extensions/toilet_status_extension.dart';
import '../riverpod/toilets_provider.dart';
import '../widgets/shimmer/shimmer_box.dart';

part '../widgets/toilet_location_body.dart';
part '../widgets/toilet_card.dart';
part '../widgets/toilet_search_field.dart';
part '../widgets/toilet_summary_row.dart';
part '../widgets/shimmer/toilet_list_shimmer.dart';
part '../widgets/shimmer/toilet_summary_row_shimmer.dart';

class ToiletLocationPage extends ConsumerStatefulWidget {
  const ToiletLocationPage({super.key});

  @override
  ConsumerState<ToiletLocationPage> createState() => _ToiletLocationPageState();
}

class _ToiletLocationPageState extends ConsumerState<ToiletLocationPage> {
  ToiletListFilter _selectedFilter = ToiletListFilter.all;
  String _searchQuery = '';
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onFilterSelected(ToiletListFilter filter) {
    if (_selectedFilter == filter) {
      return;
    }

    setState(() => _selectedFilter = filter);
    ref.read(toiletsProvider.notifier).filter(filter);
  }

  void _onSearchChanged(String query) {
    setState(() => _searchQuery = query);
  }

  void _onToiletTap(ToiletEntity toilet) {
    context.pushNamed(
      Routes.toiletDetails,
      pathParameters: {'id': toilet.id.toString()},
    );
  }

  void _onBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.goNamed(Routes.shift);
    }
  }

  @override
  Widget build(BuildContext context) {
    final toiletsAsync = ref.watch(toiletsProvider);

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: DetailAppBar(
        title: context.locale.toiletLocation,
        onBack: () => _onBack(context),
      ),
      body: _ToiletLocationBody(
        toiletsAsync: toiletsAsync,
        selectedFilter: _selectedFilter,
        onFilterSelected: _onFilterSelected,
        searchQuery: _searchQuery,
        searchController: _searchController,
        onSearchChanged: _onSearchChanged,
        onToiletTap: _onToiletTap,
        onRetry: () =>
            ref.read(toiletsProvider.notifier).fetch(filter: _selectedFilter),
      ),
    );
  }
}
