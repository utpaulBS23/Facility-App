import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../core/gen/assets.gen.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/text/typography.dart';

class NoShiftTodayWidget extends StatelessWidget {
  const NoShiftTodayWidget({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final padding = context.dimensions.padding;

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: AppBar(
        title: Headline2xlTinyText(context.locale.noShiftToday),
        backgroundColor: context.color.onPrimary,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        titleSpacing: spacing.s16,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: padding.p16),
              child: Column(
                children: [
                  Gap(spacing.s40),
                  // WHY: Circular container mirrors the "pending" hero in
                  // ApprovalRequestPage to keep the status-screen language consistent.
                  Container(
                    width: spacing.s80,
                    height: spacing.s80,
                    decoration: BoxDecoration(
                      color: context.color.warningAlt,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Assets.icons.warning.svg(
                        width: spacing.s40,
                        height: spacing.s40,
                        colorFilter: ColorFilter.mode(
                          context.color.warning,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                  Gap(spacing.s24),
                  HeadlineMediumText(
                    context.locale.noShiftToday,
                    textAlign: TextAlign.center,
                  ),
                  Gap(spacing.s12),
                  BodyRegularText.secondary(
                    message,
                    textAlign: TextAlign.center,
                  ),
                  Gap(spacing.s32),
                  _HelpCard(text: context.locale.noShiftTodayHelp),
                  Gap(spacing.s40),
                ],
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                padding.p16,
                spacing.s16,
                padding.p16,
                spacing.s16,
              ),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => context.goNamed(Routes.shift),
                  child: Text(context.locale.shift),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HelpCard extends StatelessWidget {
  const _HelpCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Container(
      padding: EdgeInsets.all(context.dimensions.padding.p16),
      decoration: BoxDecoration(
        color: context.color.brandSubtle,
        borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Assets.icons.info.svg(
            width: spacing.s20,
            height: spacing.s20,
            colorFilter: ColorFilter.mode(
              context.color.primary,
              BlendMode.srcIn,
            ),
          ),
          Gap(spacing.s12),
          Expanded(
            child: BodySmallText(
              text,
              color: context.color.text.secondary,
            ),
          ),
        ],
      ),
    );
  }
}
