import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/toilet_location/toilet_entity.dart';
import '../../../../domain/entities/toilet_location/toilet_target_entity.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/number_formatter.dart';
import '../../../core/widgets/detail_app_bar.dart';
import '../extensions/toilet_direction_extension.dart';
import '../extensions/toilet_status_extension.dart';
import '../riverpod/toilets_provider.dart';
import '../riverpod/toilet_target_provider.dart';
import '../widgets/shimmer/shimmer_box.dart';

part '../widgets/toilet_detail_header_card.dart';
part '../widgets/toilet_detail_stats_card.dart';
part '../widgets/toilet_target_card.dart';
part '../widgets/toilet_supervisor_card.dart';
part '../widgets/shimmer/toilet_details_shimmer.dart';

class ToiletDetailsPage extends ConsumerWidget {
  const ToiletDetailsPage({super.key, required this.facilityId});

  final int facilityId;

  void _onBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.goNamed(Routes.toiletLocation);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final toiletsAsync = ref.watch(toiletsProvider);
    final targetAsync = ref.watch(toiletTargetProvider(facilityId));
    final spacing = context.dimensions.spacing;

    final toilet = toiletsAsync.valueOrNull?.list.items
        .where((f) => f.id == facilityId)
        .firstOrNull;

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: DetailAppBar(
        title: context.locale.toiletDetails,
        onBack: () => _onBack(context),
      ),
      body: toilet == null
          ? const _ToiletDetailsShimmer()
          : SingleChildScrollView(
              padding: EdgeInsets.all(spacing.s16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _ToiletStatusBanner(toilet: toilet),
                  Gap(spacing.s12),
                  _ToiletDetailHeaderCard(toilet: toilet),
                  Gap(spacing.s12),
                  targetAsync.when(
                    data: (target) => _ToiletDetailStatsCard(target: target),
                    loading: () => const _ToiletDetailStatsCardShimmer(),
                    error: (err, _) => const SizedBox.shrink(),
                  ),
                  Gap(spacing.s12),
                  targetAsync.when(
                    data: (target) => _ToiletTargetCard(target: target),
                    loading: () => const _ToiletTargetCardShimmer(),
                    error: (err, _) => const SizedBox.shrink(),
                  ),
                  Gap(spacing.s12),
                  targetAsync.when(
                    data: (target) => _ToiletSupervisorCard(
                      facilityName: toilet.name,
                      supervisorName: target.supervisorName,
                    ),
                    loading: () => const _ToiletSupervisorCardShimmer(),
                    error: (err, _) => _ToiletSupervisorCard(
                      facilityName: toilet.name,
                      supervisorName: '',
                    ),
                  ),
                  Gap(spacing.s16),
                  SizedBox(
                    height: spacing.s48,
                    child: FilledButton(
                      onPressed: () => toilet.openDirection(),
                      style: FilledButton.styleFrom(
                        backgroundColor: context.color.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            context.dimensions.radius.r10,
                          ),
                        ),
                      ),
                      child: Text(context.locale.direction),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
