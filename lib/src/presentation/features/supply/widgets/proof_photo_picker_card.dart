part of '../view/delivery_complaint_page.dart';

class _ProofPhotoPickerCard extends StatelessWidget {
  const _ProofPhotoPickerCard({
    required this.onCameraTap,
    required this.onGalleryTap,
  });

  final VoidCallback onCameraTap;
  final VoidCallback onGalleryTap;

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
          RichText(
            text: TextSpan(
              text: 'Proof photo ',
              style: context.textStyle.labelLarge.copyWith(
                color: color.text.primary,
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                  text: '*',
                  style: TextStyle(color: color.primary),
                ),
              ],
            ),
          ),
          Gap(spacing.s12),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 44,
                  child: FilledButton.icon(
                    onPressed: onCameraTap,
                    icon: const Icon(Icons.camera_alt_outlined, size: 18),
                    label: const Text('Camera'),
                  ),
                ),
              ),
              Gap(spacing.s12),
              Expanded(
                child: SizedBox(
                  height: 44,
                  child: OutlinedButton.icon(
                    onPressed: onGalleryTap,
                    icon: const Icon(Icons.image_outlined, size: 18),
                    label: const Text('Gallery'),
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
