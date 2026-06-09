import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/gen/assets.gen.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/text/typography.dart';

class ShiftStatusPage extends StatelessWidget {
  const ShiftStatusPage({
    super.key,
    required this.heroColor,
    required this.icon,
    required this.title,
    required this.message,
    required this.helpText,
    required this.buttonLabel,
    required this.onButton,
  });

  final Color heroColor;
  final IconData icon;
  final String title;
  final String message;
  final String helpText;
  final String buttonLabel;
  final VoidCallback onButton;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final padding = context.dimensions.padding;
    final colors = context.color;

    return Scaffold(
      backgroundColor: heroColor,
      body: Column(
        children: [
          SafeArea(
            bottom: false,
            child: SizedBox(
              height: spacing.s180,
              child: Center(
                child: Container(
                  width: spacing.s96,
                  height: spacing.s96,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: spacing.s48, color: Colors.white),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: colors.scaffoldBackground,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(context.dimensions.radius.r20),
                  topRight: Radius.circular(context.dimensions.radius.r20),
                ),
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  padding.p16,
                  spacing.s32,
                  padding.p16,
                  spacing.s16,
                ),
                child: Column(
                  crossAxisAlignment: .center,
                  children: [
                    HeadlineMediumText(title, textAlign: TextAlign.center),
                    Gap(spacing.s12),
                    BodyRegularText.secondary(
                      message,
                      textAlign: TextAlign.center,
                    ),
                    Gap(spacing.s24),
                    _HelpCard(text: helpText),
                  ],
                ),
              ),
            ),
          ),
          ColoredBox(
            color: colors.scaffoldBackground,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  padding.p16,
                  spacing.s8,
                  padding.p16,
                  spacing.s16,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: onButton,
                    child: Text(buttonLabel),
                  ),
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
        crossAxisAlignment: .start,
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
            child: BodySmallText(text, color: context.color.text.secondary),
          ),
        ],
      ),
    );
  }
}
