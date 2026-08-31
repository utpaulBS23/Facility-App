import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../core/application_state/session_provider/session_provider.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/text/typography.dart';
import '../widgets/facility_selector_card.dart';
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

  @override
  Widget build(BuildContext context) {
    final color = context.color;
    final spacing = context.dimensions.spacing;
    final facilities =
        ref.watch(userSessionProvider)?.accessibleFacilities ?? const [];

    _selectedFacilityId ??=
        widget.args?.facilityId ?? facilities.firstOrNull?.id;

    final selectedFacilityName = facilities
            .where((f) => f.id == _selectedFacilityId)
            .firstOrNull
            ?.name ??
        '';

    return Scaffold(
      backgroundColor: color.scaffoldBackground,
      appBar: AppBar(
        leading: AppBackButton(onTap: () => context.goNamed(Routes.shift)),
        leadingWidth: AppBackButton.width,
        title: Headline2xlTinyText(context.locale.stock),
        centerTitle: true,
        backgroundColor: color.onPrimary,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(spacing.s16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (facilities.isNotEmpty) ...[
              FacilitySelectorCard(
                facilityName: selectedFacilityName.isEmpty
                    ? context.locale.selectFacility
                    : selectedFacilityName,
                onTap: () => showFacilitySelectorSheet(
                  context: context,
                  facilities: facilities,
                  selectedFacilityId: _selectedFacilityId,
                  onSelected: (id) => setState(() => _selectedFacilityId = id),
                ),
              ),
              Gap(spacing.s16),
            ],
            FacilityStockBalanceBody(facilityId: _selectedFacilityId),
          ],
        ),
      ),
    );
  }
}
