import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/visit_entity.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/text/typography.dart';
import '../riverpod/visit_detail_provider.dart';

part '../widgets/visit_detail_info_card.dart';
part '../widgets/visit_detail_purpose_card.dart';

class VisitDetailPage extends ConsumerStatefulWidget {
  const VisitDetailPage({super.key, required this.visitId});

  final int visitId;

  @override
  ConsumerState<VisitDetailPage> createState() => _VisitDetailPageState();
}

class _VisitDetailPageState extends ConsumerState<VisitDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => ref
          .read(visitDetailProvider.notifier)
          .fetch(visitId: widget.visitId),
    );
  }

  void _onCheckIn(VisitDetailEntity detail) {
    context.pushNamed(Routes.visitCheckIn, extra: detail);
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final detailState = ref.watch(visitDetailProvider);

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: AppBar(
        title: LabelLargeText(context.locale.visitDetails),
        backgroundColor: context.color.onPrimary,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
      ),
      body: detailState.when(
        loading: () => const Center(child: CircularProgressIndicator.adaptive()),
        error: (err, _) => Center(
          child: Column(
            mainAxisSize: .min,
            children: [
              Text(
                err.toString(),
                style: context.textStyle.bodyMedium.copyWith(
                  color: context.color.text.secondary,
                ),
                textAlign: TextAlign.center,
              ),
              Gap(spacing.s16),
              TextButton(
                onPressed: () => ref
                    .read(visitDetailProvider.notifier)
                    .fetch(visitId: widget.visitId),
                child: Text(context.locale.retry),
              ),
            ],
          ),
        ),
        data: (detail) => SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(spacing.s16),
            child: Column(
              crossAxisAlignment: .stretch,
              children: [
                _VisitDetailInfoCard(detail: detail),
                Gap(spacing.s12),
                _VisitDetailPurposeCard(detail: detail),
                Gap(spacing.s12),
                FilledButton(
                  onPressed: () => _onCheckIn(detail),
                  style: FilledButton.styleFrom(
                    backgroundColor: context.color.success,
                    minimumSize: const Size.fromHeight(44),
                    shape: RoundedRectangleBorder(
                      borderRadius: .circular(context.dimensions.radius.r12),
                    ),
                  ),
                  child: LabelLargeText(
                    context.locale.checkInToVisit,
                    color: context.color.onPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
