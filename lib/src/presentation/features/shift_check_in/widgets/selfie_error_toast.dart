// Author: Claude AI Assistant
// Created: 2026-04-09

part of '../view/shift_check_in_page.dart';

/// Warning toast shown when selfie capture fails, prompting the user
/// to request supervisor assistance for manual check-in processing.
///
/// Matches the Figma "Toast" component (node 13045:27380).
class _SelfieErrorToast extends StatelessWidget {
  const _SelfieErrorToast({required this.onRequestSupervisor});

  final VoidCallback onRequestSupervisor;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final dimensions = context.dimensions;
    final locale = context.locale;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(dimensions.padding.p16),
      decoration: BoxDecoration(
        color: colors.warningAlt,
        borderRadius: BorderRadius.circular(dimensions.radius.r12),
        border: Border.all(color: colors.warning, width: 2),
        boxShadow: [
          BoxShadow(
            color: colors.shadow,
            offset: const Offset(0, 2),
            blurRadius: 14,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Assets.icons.warning.svg(
            width: dimensions.spacing.s20,
            height: dimensions.spacing.s20,
          ),
          Gap(dimensions.spacing.s8),
          Expanded(
            child: Text.rich(
              TextSpan(
                style: context.textStyle.bodyRegular.copyWith(
                  color: colors.text.primary,
                ),
                children: [
                  TextSpan(text: locale.cantTakeSelfie),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.baseline,
                    baseline: TextBaseline.alphabetic,
                    child: GestureDetector(
                      onTap: onRequestSupervisor,
                      child: Text(
                        locale.requestSupervisor,
                        style: context.textStyle.bodyRegular.copyWith(
                          color: colors.text.primary,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                  TextSpan(text: locale.toManuallyProcessCheckIn),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
