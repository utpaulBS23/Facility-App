import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/visit_entity.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/text/typography.dart';
import '../riverpod/visit_check_in_provider.dart';
import '../riverpod/visit_detail_provider.dart';

part '../widgets/visit_detail_info_card.dart';
part '../widgets/visit_detail_purpose_card.dart';
part '../widgets/visit_check_in_facility_card.dart';
part '../widgets/visit_check_in_location_card.dart';

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

  Future<void> _onCheckIn() async {
    await ref
        .read(visitCheckInProvider.notifier)
        .captureCheckIn(visitId: widget.visitId);
  }

  Future<void> _onConfirm(VisitDetailEntity detail) async {
    await ref
        .read(visitCheckInProvider.notifier)
        .confirmCheckIn(visitId: widget.visitId);

    if (!mounted) return;
    final checkInState = ref.read(visitCheckInProvider);
    if (checkInState.checkInSuccess) {
      context.pushReplacementNamed(
        Routes.inspectionChecklist,
        extra: detail,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final detailState = ref.watch(visitDetailProvider);
    final checkInState = ref.watch(visitCheckInProvider);

    final isCheckInPhase = checkInState.hasCaptureResult;
    final appBarTitle = isCheckInPhase
        ? context.locale.visitCheckIn
        : context.locale.visitDetails;

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: AppBar(
        title: LabelLargeText(appBarTitle),
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
            child: isCheckInPhase
                ? _CheckInBody(
                    detail: detail,
                    checkInState: checkInState,
                    captureResult: checkInState.captureResult!,
                    onConfirm: () => _onConfirm(detail),
                    onRetry: () => ref
                        .read(visitCheckInProvider.notifier)
                        .retryCapture(visitId: widget.visitId),
                  )
                : _DetailBody(
                    detail: detail,
                    checkInState: checkInState,
                    onCheckIn: _onCheckIn,
                  ),
          ),
        ),
      ),
    );
  }
}

class _DetailBody extends StatelessWidget {
  const _DetailBody({
    required this.detail,
    required this.checkInState,
    required this.onCheckIn,
  });

  final VisitDetailEntity detail;
  final VisitCheckInState checkInState;
  final VoidCallback onCheckIn;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Column(
      crossAxisAlignment: .stretch,
      children: [
        _VisitDetailInfoCard(detail: detail),
        Gap(spacing.s12),
        _VisitDetailPurposeCard(detail: detail),
        Gap(spacing.s12),
        if (checkInState.isBusy)
          Container(
            height: 44,
            decoration: BoxDecoration(
              color: context.color.success,
              borderRadius: .circular(context.dimensions.radius.r12),
            ),
            child: const Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator.adaptive(
                  strokeWidth: 2,
                  backgroundColor: Colors.white,
                ),
              ),
            ),
          )
        else ...[
          if (checkInState.captureError != null ||
              checkInState.locationError != null) ...[
            Text(
              checkInState.captureError ?? checkInState.locationError!,
              style: context.textStyle.bodySmall
                  .copyWith(color: context.color.error),
              textAlign: TextAlign.center,
            ),
            Gap(spacing.s8),
          ],
          FilledButton(
            onPressed: onCheckIn,
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
      ],
    );
  }
}

class _CheckInBody extends StatelessWidget {
  const _CheckInBody({
    required this.detail,
    required this.checkInState,
    required this.captureResult,
    required this.onConfirm,
    required this.onRetry,
  });

  final VisitDetailEntity detail;
  final VisitCheckInState checkInState;
  final VisitCheckInCaptureEntity captureResult;
  final VoidCallback onConfirm;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Column(
      crossAxisAlignment: .stretch,
      children: [
        _VisitCheckInFacilityCard(detail: detail),
        Gap(spacing.s12),
        _VisitCheckInLocationCard(
          state: checkInState,
          captureResult: captureResult,
          onRetry: onRetry,
        ),
        Gap(spacing.s12),
        if (checkInState.checkInError != null) ...[
          Text(
            checkInState.checkInError!,
            style: context.textStyle.bodySmall
                .copyWith(color: context.color.error),
            textAlign: TextAlign.center,
          ),
          Gap(spacing.s8),
        ],
        FilledButton(
          onPressed: checkInState.isCheckingIn ? null : onConfirm,
          style: FilledButton.styleFrom(
            backgroundColor: context.color.success,
            disabledBackgroundColor: context.color.disabled,
            minimumSize: const Size.fromHeight(44),
            shape: RoundedRectangleBorder(
              borderRadius: .circular(context.dimensions.radius.r12),
            ),
          ),
          child: checkInState.isCheckingIn
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator.adaptive(
                    strokeWidth: 2,
                    backgroundColor: Colors.white,
                  ),
                )
              : LabelLargeText(
                  context.locale.confirmCheckIn,
                  color: context.color.onPrimary,
                ),
        ),
      ],
    );
  }
}
