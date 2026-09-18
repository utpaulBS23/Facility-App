import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/accessible_facility_entity.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/facility_filter_button.dart';
import '../../../core/widgets/facility_picker_sheet.dart';
import '../../../core/widgets/text/typography.dart';
import '../../../core/application_state/session_provider/session_provider.dart';
import '../widgets/facility_stock_balance_body.dart';

class StockPageArgs {
  const StockPageArgs({
    required this.facilityId,
    this.shiftAssignmentId,
  });

  final int facilityId;
  final int? shiftAssignmentId;
}

class StockPage extends ConsumerStatefulWidget {
  const StockPage({super.key, this.args});

  final StockPageArgs? args;

  @override
  ConsumerState<StockPage> createState() => _StockPageState();
}

class _StockPageState extends ConsumerState<StockPage> {
  int? _selectedFacilityId;

  @override
  void initState() {
    super.initState();
    _selectedFacilityId = widget.args?.facilityId;
  }

  void _onBack(BuildContext context) {
    context.goNamed(Routes.shift);
  }

  Future<void> _showFacilitySelector(
    BuildContext context,
    List<AccessibleFacilityEntity> facilities,
  ) async {
    final result = await showModalBottomSheet<({int? facilityId})>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FacilityPickerSheet(
        facilities: facilities,
        selectedFacilityId: _selectedFacilityId,
      ),
    );
    if (result == null || result.facilityId == _selectedFacilityId) return;
    setState(() => _selectedFacilityId = result.facilityId);
  }

  @override
  Widget build(BuildContext context) {
    final color = context.color;
    final spacing = context.dimensions.spacing;
    final facilities = ref.watch(userSessionProvider)?.accessibleFacilities ?? const [];

    _selectedFacilityId ??= widget.args?.facilityId ?? facilities.firstOrNull?.id;

    return Scaffold(
      backgroundColor: color.scaffoldBackground,
      appBar: AppBar(
        leading: AppBackButton(onTap: () => _onBack(context)),
        leadingWidth: AppBackButton.width,
        title: Headline2xlTinyText(context.locale.stock),
        centerTitle: true,
        backgroundColor: color.onPrimary,
        surfaceTintColor: Colors.transparent,
        actions: [
          if (facilities.length > 1)
            FacilityFilterButton(
              hasSelection: _selectedFacilityId != null,
              onTap: () => _showFacilitySelector(context, facilities),
            ),
          Gap(spacing.s8),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(spacing.s16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FacilityStockBalanceBody(facilityId: _selectedFacilityId),
          ],
        ),
      ),
    );
  }
}
