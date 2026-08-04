part of '../view/delivery_complaint_page.dart';

class _AdditionalDetailsCard extends StatelessWidget {
  const _AdditionalDetailsCard({
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final color = context.color;

    return Container(
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: color.onPrimary,
        border: Border.all(color: color.borderSubtle),
        borderRadius: BorderRadius.circular(radius.r12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.locale.complaintReasonLabel,
            style: context.textStyle.bodySmall.copyWith(
              color: color.text.secondary,
            ),
          ),
          Gap(spacing.s8),
          TextField(
            controller: controller,
            maxLines: 4,
            onChanged: (_) => onChanged(),
            decoration: InputDecoration(
              hintText: context.locale.complaintReasonHint,
              hintStyle: context.textStyle.bodyMedium.copyWith(
                color: color.text.secondary,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(radius.r10),
                borderSide: BorderSide(color: color.borderSubtle),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(radius.r10),
                borderSide: BorderSide(color: color.borderSubtle),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(radius.r10),
                borderSide: BorderSide(color: color.primary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
