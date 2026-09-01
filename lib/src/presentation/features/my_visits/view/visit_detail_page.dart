import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../core/extensions/failure_localization.dart';
import '../../../../domain/entities/visit_entity.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/detail_app_bar.dart';
import '../../../core/widgets/text/typography.dart';
import '../riverpod/visit_check_in_provider.dart';
import '../riverpod/visit_detail_provider.dart';

part '../widgets/visit_detail_info_card.dart';
part '../widgets/visit_detail_purpose_card.dart';
part '../widgets/visit_check_in_location_card.dart';

class VisitDetailPage extends ConsumerStatefulWidget {
  const VisitDetailPage({
    super.key,
    required this.visitId,
    this.travelOriginType,
    this.travelOriginId,
  });

  final int visitId;

  // WHY: only available from the visit list response — carried through the
  // route `extra` since the detail endpoint doesn't return it.
  final String? travelOriginType;
  final int? travelOriginId;

  @override
  ConsumerState<VisitDetailPage> createState() => _VisitDetailPageState();
}

class _VisitDetailPageState extends ConsumerState<VisitDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref
          .read(visitDetailProvider.notifier)
          .fetch(visitId: widget.visitId);
      if (!mounted) return;
      final detail = ref.read(visitDetailProvider).valueOrNull;
      if (detail != null && detail.locationVerified) {
        context.pushReplacementNamed(Routes.inspectionChecklist, extra: detail);
      }
    });
  }

  Future<void> _onCheckIn(VisitDetailEntity detail) async {
    final facilityId = detail.facilityId;
    if (facilityId == null) return;

    await ref
        .read(visitCheckInProvider.notifier)
        .startLocationSharing(
          visitId: widget.visitId,
          facilityId: facilityId,
          travelOriginType: widget.travelOriginType,
          travelOriginId: widget.travelOriginId,
        );
  }

  Future<void> _onReshareLocation() async {
    await ref
        .read(visitCheckInProvider.notifier)
        .resumeLocationSharing(visitId: widget.visitId);
  }

  Future<void> _onConfirm(VisitDetailEntity detail) async {
    await ref
        .read(visitCheckInProvider.notifier)
        .confirmCheckIn(visitId: widget.visitId);

    if (!mounted) return;
    final checkInState = ref.read(visitCheckInProvider);
    if (checkInState.checkInSuccess) {
      context.pushReplacementNamed(Routes.inspectionChecklist, extra: detail);
    }
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final detailState = ref.watch(visitDetailProvider);
    final checkInState = ref.watch(visitCheckInProvider);
    final detail = detailState.valueOrNull;

    // WHY the travelStartedAt/travelTrackingExcluded fallback: a visit
    // excluded from travel tracking never starts ping tracking (see
    // visit_check_in_provider's WHY), so isSharingLocationFor alone can't
    // detect "check-in already started" for it — travelStartedAt being set
    // is the only signal that travel-routes/check-in already ran for this
    // visit and the flow should resume at confirm, not restart it.
    final isCheckInPhase =
        checkInState.isSharingLocationFor(widget.visitId) ||
        (detail != null &&
            detail.travelStartedAt != null &&
            detail.travelTrackingExcluded);

    // WHY: travelStartedAt set + tracking not excluded means a leg is in
    // progress and should be sharing live location — if it isn't (app
    // process killed mid-visit, tracking never resumed on relaunch), the
    // gap needs a deliberate resume, not a silent re-check-in.
    final needsReshare =
        detail != null &&
        detail.travelStartedAt != null &&
        !detail.travelTrackingExcluded &&
        !checkInState.isSharingLocationFor(widget.visitId);

    final appBarTitle = isCheckInPhase
        ? context.locale.visitCheckIn
        : context.locale.visitDetails;

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: DetailAppBar(title: appBarTitle),
      body: detailState.when(
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
        error: (err, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                err.localizedMessage(context),
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
                    onConfirm: () => _onConfirm(detail),
                  )
                : needsReshare
                ? _ReshareLocationBody(
                    detail: detail,
                    checkInState: checkInState,
                    onReshare: _onReshareLocation,
                  )
                : _DetailBody(
                    detail: detail,
                    checkInState: checkInState,
                    onCheckIn: () => _onCheckIn(detail),
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
      crossAxisAlignment: CrossAxisAlignment.stretch,
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
              borderRadius: BorderRadius.circular(
                context.dimensions.radius.r12,
              ),
            ),
            child: Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator.adaptive(
                  strokeWidth: 2,
                  backgroundColor: context.color.onPrimary,
                ),
              ),
            ),
          )
        else ...[
          if (checkInState.shareError != null) ...[
            Text(
              checkInState.shareError!.localized(context),
              style: context.textStyle.bodySmall.copyWith(
                color: context.color.error,
              ),
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
                borderRadius: BorderRadius.circular(
                  context.dimensions.radius.r12,
                ),
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

class _ReshareLocationBody extends StatelessWidget {
  const _ReshareLocationBody({
    required this.detail,
    required this.checkInState,
    required this.onReshare,
  });

  final VisitDetailEntity detail;
  final VisitCheckInState checkInState;
  final VoidCallback onReshare;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
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
              borderRadius: BorderRadius.circular(
                context.dimensions.radius.r12,
              ),
            ),
            child: Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator.adaptive(
                  strokeWidth: 2,
                  backgroundColor: context.color.onPrimary,
                ),
              ),
            ),
          )
        else ...[
          if (checkInState.shareError != null) ...[
            Text(
              checkInState.shareError!.localized(context),
              style: context.textStyle.bodySmall.copyWith(
                color: context.color.error,
              ),
              textAlign: TextAlign.center,
            ),
            Gap(spacing.s8),
          ],
          FilledButton(
            onPressed: onReshare,
            style: FilledButton.styleFrom(
              backgroundColor: context.color.success,
              minimumSize: const Size.fromHeight(44),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  context.dimensions.radius.r12,
                ),
              ),
            ),
            child: LabelLargeText(
              context.locale.reshareYourLocation,
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
    required this.onConfirm,
  });

  final VisitDetailEntity detail;
  final VisitCheckInState checkInState;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _VisitDetailInfoCard(detail: detail),
        Gap(spacing.s12),
        _VisitCheckInLocationCard(state: checkInState),
        Gap(spacing.s12),
        if (checkInState.checkInError != null) ...[
          Text(
            checkInState.checkInError!.localized(context),
            style: context.textStyle.bodySmall.copyWith(
              color: context.color.error,
            ),
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
              borderRadius: BorderRadius.circular(
                context.dimensions.radius.r12,
              ),
            ),
          ),
          child: checkInState.isCheckingIn
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator.adaptive(
                    strokeWidth: 2,
                    backgroundColor: context.color.onPrimary,
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
