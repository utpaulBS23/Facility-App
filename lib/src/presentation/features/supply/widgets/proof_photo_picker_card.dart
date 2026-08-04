part of '../view/delivery_complaint_page.dart';

/// Proof photo capture — always disabled, no upload endpoint exists yet.
class _ProofPhotoPickerCard extends StatelessWidget {
  const _ProofPhotoPickerCard();

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
            context.locale.proofPhoto,
            style: context.textStyle.labelLarge.copyWith(
              color: color.text.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          Gap(spacing.s12),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: spacing.s44,
                  child: FilledButton.icon(
                    onPressed: null,
                    icon: Icon(Icons.camera_alt_outlined, size: spacing.s20),
                    label: Text(context.locale.camera),
                  ),
                ),
              ),
              Gap(spacing.s12),
              Expanded(
                child: SizedBox(
                  height: spacing.s44,
                  child: OutlinedButton.icon(
                    onPressed: null,
                    icon: Icon(Icons.image_outlined, size: spacing.s20),
                    label: Text(context.locale.gallery),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: color.primary),
                      foregroundColor: color.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
