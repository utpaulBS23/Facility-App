part of '../view/shift_check_in_page.dart';

/// How the reason box behaves on the check-in and check-out pages.
enum _ReasonMode {
  /// On time: nothing to explain, no box.
  hidden,

  /// The slot is not known, so lateness is not known: the box stays, optional.
  optional,

  /// Late: the box is shown and a reason must be given.
  required,
}

/// The late notice and the reason box, as the [mode] asks.
class _ReasonSection extends StatelessWidget {
  const _ReasonSection({
    required this.mode,
    required this.controller,
    this.lateNotice,
  });

  final _ReasonMode mode;
  final TextEditingController controller;
  final String? lateNotice;

  @override
  Widget build(BuildContext context) {
    if (mode == _ReasonMode.hidden) return const SizedBox.shrink();

    final spacing = context.dimensions.spacing;
    final notice = lateNotice;
    final label = mode == _ReasonMode.required
        ? '${context.locale.reason} *'
        : context.locale.reason;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (notice != null) ...[
          Container(
            padding: EdgeInsets.all(spacing.s12),
            decoration: BoxDecoration(
              color: context.color.warningAlt,
              border: Border.all(color: context.color.warning),
              borderRadius: BorderRadius.circular(
                context.dimensions.radius.r12,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.schedule_rounded,
                  size: 18,
                  color: context.color.warning,
                ),
                Gap(spacing.s8),
                Expanded(
                  child: Text(
                    notice,
                    style: context.textStyle.bodySmall.copyWith(
                      color: context.color.text.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Gap(spacing.s12),
        ],
        AppTextField.description(controller: controller, label: label),
        Gap(spacing.s16),
      ],
    );
  }
}
