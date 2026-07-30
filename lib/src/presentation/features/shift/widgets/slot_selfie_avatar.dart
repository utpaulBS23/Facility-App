part of '../view/shift_tab.dart';

/// Circular selfie thumbnail with the design's hairline ring.
class _SlotSelfieAvatar extends StatelessWidget {
  const _SlotSelfieAvatar({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Container(
      width: spacing.s40,
      height: spacing.s40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: context.color.borderSubtle,
          width: spacing.s2,
        ),
      ),
      child: ClipOval(
        child: Image.network(
          url,
          fit: BoxFit.cover,
          loadingBuilder: (_, child, progress) => progress == null
              ? child
              : Center(
                  child: CircularProgressIndicator(
                    strokeWidth: spacing.s2,
                    value: progress.expectedTotalBytes != null
                        ? progress.cumulativeBytesLoaded /
                              progress.expectedTotalBytes!
                        : null,
                  ),
                ),
          errorBuilder: (_, _, _) => Container(
            color: context.color.subtle,
            child: Icon(
              Icons.broken_image_outlined,
              color: context.color.text.muted,
              size: spacing.s16,
            ),
          ),
        ),
      ),
    );
  }
}
