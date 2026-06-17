import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/visit_entity.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/text/typography.dart';
import '../riverpod/visit_check_in_provider.dart';

part '../widgets/visit_check_in_facility_card.dart';
part '../widgets/visit_check_in_location_card.dart';

class VisitCheckInPage extends ConsumerStatefulWidget {
  const VisitCheckInPage({super.key, required this.detail});

  final VisitDetailEntity detail;

  @override
  ConsumerState<VisitCheckInPage> createState() => _VisitCheckInPageState();
}

class _VisitCheckInPageState extends ConsumerState<VisitCheckInPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => ref.read(visitCheckInProvider.notifier).getLocation(),
    );
  }

  Future<void> _onConfirm() async {
    await ref
        .read(visitCheckInProvider.notifier)
        .confirmCheckIn(visitId: widget.detail.id);

    if (!mounted) return;
    final state = ref.read(visitCheckInProvider);
    if (state.checkInSuccess) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final checkInState = ref.watch(visitCheckInProvider);

    final canConfirm =
        checkInState.hasLocation && !checkInState.isCheckingIn;

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: AppBar(
        title: LabelLargeText(context.locale.visitCheckIn),
        backgroundColor: context.color.onPrimary,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(spacing.s16),
        child: Column(
          crossAxisAlignment: .stretch,
          children: [
            _VisitCheckInFacilityCard(detail: widget.detail),
            Gap(spacing.s12),
            _VisitCheckInLocationCard(
              detail: widget.detail,
              state: checkInState,
              onRetry: () =>
                  ref.read(visitCheckInProvider.notifier).getLocation(),
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
              onPressed: canConfirm ? _onConfirm : null,
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
        ),
      ),
    );
  }
}
