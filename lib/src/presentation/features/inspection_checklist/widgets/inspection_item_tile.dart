part of '../view/inspection_checklist_page.dart';

class _InspectionItemTile extends StatelessWidget {
  const _InspectionItemTile({required this.item, required this.state});

  final ChecklistItemEntity item;
  final InspectionChecklistState state;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: spacing.s12),
      child: Row(
        crossAxisAlignment: .start,
        children: [
          _ItemOrderBadge(order: item.order),
          SizedBox(width: spacing.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                LabelLargeText(item.question, color: context.color.text.primary),
                SizedBox(height: spacing.s8),
                if (item.answerType == ChecklistAnswerType.star)
                  _StarRatingRow(item: item, state: state)
                else
                  _YesNoRow(item: item, state: state),
                if (item.proofPolicy != ChecklistProofPolicy.none) ...[
                  SizedBox(height: spacing.s8),
                  _ProofAttachmentRow(item: item),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemOrderBadge extends StatelessWidget {
  const _ItemOrderBadge({required this.order});

  final int order;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: context.color.background.surface,
        borderRadius: .circular(8),
      ),
      alignment: .center,
      child: LabelLargeText('$order', color: context.color.text.primary),
    );
  }
}

class _StarRatingRow extends ConsumerWidget {
  const _StarRatingRow({required this.item, required this.state});

  final ChecklistItemEntity item;
  final InspectionChecklistState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = context.dimensions.spacing;
    final currentRating = state.starAnswers[item.id] ?? 0;

    return Row(
      children: [
        ...List.generate(item.maxPoints, (index) {
          final starValue = index + 1;
          final isFilled = starValue <= currentRating;
          return GestureDetector(
            onTap: () => ref
                .read(inspectionChecklistProvider.notifier)
                .setStarRating(itemId: item.id, rating: starValue),
            child: Padding(
              padding: EdgeInsets.only(right: spacing.s4),
              child: Icon(
                isFilled ? Icons.star_rounded : Icons.star_outline_rounded,
                size: 24,
                color: isFilled
                    ? const Color(0xFFF59E0B)
                    : context.color.borderSubtle,
              ),
            ),
          );
        }),
        if (currentRating > 0) ...[
          SizedBox(width: spacing.s4),
          LabelLargeText('$currentRating', color: context.color.text.primary),
        ],
      ],
    );
  }
}

class _YesNoRow extends ConsumerWidget {
  const _YesNoRow({required this.item, required this.state});

  final ChecklistItemEntity item;
  final InspectionChecklistState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = context.dimensions.spacing;
    final answer = state.yesNoAnswers[item.id];

    return Row(
      children: [
        _YesNoChip(
          label: context.locale.yes,
          icon: Icons.check_rounded,
          isSelected: answer == true,
          selectedColor: context.color.success,
          onTap: () => ref
              .read(inspectionChecklistProvider.notifier)
              .setYesNo(itemId: item.id, value: true),
        ),
        SizedBox(width: spacing.s8),
        _YesNoChip(
          label: context.locale.no,
          icon: Icons.close_rounded,
          isSelected: answer == false,
          selectedColor: context.color.error,
          onTap: () => ref
              .read(inspectionChecklistProvider.notifier)
              .setYesNo(itemId: item.id, value: false),
        ),
      ],
    );
  }
}

class _YesNoChip extends StatelessWidget {
  const _YesNoChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.selectedColor,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final Color selectedColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 32,
        padding: EdgeInsets.symmetric(horizontal: spacing.s12, vertical: spacing.s8),
        decoration: BoxDecoration(
          color: isSelected
              ? selectedColor.withValues(alpha: 0.08)
              : context.color.onPrimary,
          borderRadius: .circular(radius.r12),
          border: Border.all(
            color: isSelected ? selectedColor : context.color.borderSubtle,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: .min,
          children: [
            Icon(icon, size: 12, color: selectedColor),
            SizedBox(width: spacing.s8),
            LabelLargeText(
              label,
              color: context.color.text.primary,
            ),
          ],
        ),
      ),
    );
  }
}

class _ProofAttachmentRow extends ConsumerWidget {
  const _ProofAttachmentRow({required this.item});

  final ChecklistItemEntity item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(inspectionChecklistProvider);
    final spacing = context.dimensions.spacing;
    final localImages = state.proofImages[item.id] ?? [];
    final hasAnyProof = item.hasProof || localImages.isNotEmpty;
    final totalCount = (item.hasProof ? 1 : 0) + localImages.length;

    return Row(
      children: [
        if (hasAnyProof) ...[
          _PhotoAttachedChip(count: totalCount),
          SizedBox(width: spacing.s8),
        ],
        if (!hasAnyProof)
          _AttachPhotoButton(
            onTap: () => ref
                .read(inspectionChecklistProvider.notifier)
                .pickProofImage(itemId: item.id),
          ),
        if (hasAnyProof) ...[
          const Spacer(),
          _RemoveProofButton(
            onTap: localImages.isNotEmpty
                ? () => ref
                    .read(inspectionChecklistProvider.notifier)
                    .removeProofImage(itemId: item.id)
                : () => ref
                    .read(inspectionChecklistProvider.notifier)
                    .pickProofImage(itemId: item.id),
          ),
        ],
      ],
    );
  }
}

class _PhotoAttachedChip extends StatelessWidget {
  const _PhotoAttachedChip({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.s12,
        vertical: spacing.s8,
      ),
      decoration: BoxDecoration(
        color: context.color.successAlt,
        borderRadius: .circular(10),
        border: Border.all(color: context.color.success),
      ),
      child: Row(
        mainAxisSize: .min,
        children: [
          Icon(Icons.camera_alt_outlined, size: 14, color: context.color.success),
          SizedBox(width: spacing.s8),
          BodySmallText(
            context.locale.photoAttached,
            color: context.color.text.primary,
          ),
          SizedBox(width: spacing.s8),
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: context.color.success,
              shape: BoxShape.circle,
            ),
            alignment: .center,
            child: Text(
              '$count',
              style: context.textStyle.bodySmall.copyWith(
                color: context.color.onPrimary,
                fontSize: 9,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AttachPhotoButton extends StatelessWidget {
  const _AttachPhotoButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.dimensions.spacing.s12,
          vertical: context.dimensions.spacing.s8,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: context.color.borderSubtle),
          borderRadius: .circular(10),
        ),
        child: Row(
          mainAxisSize: .min,
          children: [
            Icon(
              Icons.camera_alt_outlined,
              size: 14,
              color: context.color.text.secondary,
            ),
            SizedBox(width: context.dimensions.spacing.s8),
            BodySmallText(
              context.locale.attachPhoto,
              color: context.color.text.secondary,
            ),
          ],
        ),
      ),
    );
  }
}

class _RemoveProofButton extends StatelessWidget {
  const _RemoveProofButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: context.color.primary,
            width: 1.5,
          ),
        ),
        alignment: .center,
        child: Icon(
          Icons.delete_outline_rounded,
          size: 16,
          color: context.color.primary,
        ),
      ),
    );
  }
}
