part of '../view/add_facility_expense_page.dart';

class _DropdownField extends StatelessWidget {
  const _DropdownField({
    required this.value,
    required this.hint,
    this.onTap,
    this.hasError = false,
  });

  final String? value;
  final String hint;
  final VoidCallback? onTap;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    final radius = context.dimensions.radius;
    final spacing = context.dimensions.spacing;
    final isDisabled = onTap == null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: spacing.s56,
            decoration: BoxDecoration(
              color: isDisabled ? context.color.subtle : null,
              border: Border.all(
                color: hasError
                    ? context.color.error
                    : context.color.borderSubtle,
              ),
              borderRadius: BorderRadius.circular(radius.r12),
            ),
            padding: EdgeInsets.symmetric(horizontal: spacing.s16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value ?? hint,
                    overflow: TextOverflow.ellipsis,
                    style: value == null
                        ? context.textStyle.bodyMedium.copyWith(
                            color: context.color.text.secondary,
                          )
                        : context.textStyle.bodyMedium,
                  ),
                ),
                if (!isDisabled)
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: context.color.text.secondary,
                  ),
              ],
            ),
          ),
        ),
        if (hasError) ...[
          Gap(spacing.s4),
          BodySmallText(
            context.locale.fieldRequired,
            color: context.color.error,
          ),
        ],
      ],
    );
  }
}
