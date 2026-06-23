part of '../view/inspection_checklist_page.dart';

// WHY: intentionally ConsumerWidget — single provider-access point for all tile interactions;
// child widgets are pure StatelessWidgets that receive data and callbacks only.
class _InspectionItemTile extends ConsumerWidget {
  const _InspectionItemTile({required this.item, required this.state});

  final ChecklistItemEntity item;
  final InspectionChecklistState state;

  void _onStarTap(WidgetRef ref, int rating) {
    ref.read(inspectionChecklistProvider.notifier).setStarRating(itemId: item.id, rating: rating);
  }

  void _onYesNo(WidgetRef ref, bool value) {
    ref.read(inspectionChecklistProvider.notifier).setYesNo(itemId: item.id, value: value);
  }

  void _onPickProof(WidgetRef ref) {
    ref.read(inspectionChecklistProvider.notifier).pickProofImage(itemId: item.id);
  }

  void _onRemoveProof(WidgetRef ref) {
    ref.read(inspectionChecklistProvider.notifier).removeProofImage(itemId: item.id);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = context.dimensions.spacing;

    return Padding(
      padding: .symmetric(vertical: spacing.s12),
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
                  _StarRatingRow(
                    currentRating: state.starAnswers[item.id] ?? 0,
                    maxPoints: item.maxPoints,
                    onStarTap: (r) => _onStarTap(ref, r),
                  )
                else
                  _YesNoRow(
                    answer: state.yesNoAnswers[item.id],
                    onAnswer: (v) => _onYesNo(ref, v),
                  ),
                if (item.proofPolicy != ChecklistProofPolicy.none) ...[
                  SizedBox(height: spacing.s8),
                  _ProofAttachmentRow(
                    proofImages: state.proofImages[item.id] ?? [],
                    hasExistingProof: item.hasProof,
                    onAttach: () => _onPickProof(ref),
                    onRemove: () => _onRemoveProof(ref),
                  ),
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
    final radius = context.dimensions.radius;

    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: context.color.subtle,
        borderRadius: .circular(radius.r6),
      ),
      alignment: .center,
      child: LabelLargeText('$order', color: context.color.text.primary),
    );
  }
}

class _StarRatingRow extends StatelessWidget {
  const _StarRatingRow({
    required this.currentRating,
    required this.maxPoints,
    required this.onStarTap,
  });

  final int currentRating;
  final int maxPoints;
  final ValueChanged<int> onStarTap;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Row(
      children: [
        ...List.generate(maxPoints, (index) {
          final starValue = index + 1;
          final isFilled = starValue <= currentRating;
          return GestureDetector(
            onTap: () => onStarTap(starValue),
            child: Padding(
              padding: .only(right: spacing.s4),
              child: Icon(
                isFilled ? Icons.star_rounded : Icons.star_outline_rounded,
                size: 24,
                color: isFilled ? context.color.warning : context.color.border,
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

class _YesNoRow extends StatelessWidget {
  const _YesNoRow({
    required this.answer,
    required this.onAnswer,
  });

  final bool? answer;
  final ValueChanged<bool> onAnswer;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Row(
      children: [
        _YesNoChip(
          label: context.locale.yes,
          icon: Icons.check_rounded,
          isSelected: answer == true,
          selectedColor: context.color.success,
          onTap: () => onAnswer(true),
        ),
        SizedBox(width: spacing.s8),
        _YesNoChip(
          label: context.locale.no,
          icon: Icons.close_rounded,
          isSelected: answer == false,
          selectedColor: context.color.error,
          onTap: () => onAnswer(false),
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
        padding: .symmetric(horizontal: spacing.s12, vertical: spacing.s8),
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

class _ProofAttachmentRow extends StatelessWidget {
  const _ProofAttachmentRow({
    required this.proofImages,
    required this.hasExistingProof,
    required this.onAttach,
    required this.onRemove,
  });

  final List<XFile> proofImages;
  final bool hasExistingProof;
  final VoidCallback onAttach;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final hasAnyProof = hasExistingProof || proofImages.isNotEmpty;
    final totalCount = (hasExistingProof ? 1 : 0) + proofImages.length;

    return Row(
      children: [
        if (hasAnyProof) ...[
          _PhotoAttachedChip(count: totalCount),
          SizedBox(width: spacing.s8),
        ],
        if (!hasAnyProof)
          _AttachPhotoButton(onTap: onAttach),
        if (hasAnyProof) ...[
          const Spacer(),
          _RemoveProofButton(
            onTap: proofImages.isNotEmpty ? onRemove : onAttach,
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
    final radius = context.dimensions.radius;

    return Container(
      padding: .symmetric(
        horizontal: spacing.s12,
        vertical: spacing.s8,
      ),
      decoration: BoxDecoration(
        color: context.color.successAlt,
        borderRadius: .circular(radius.r10),
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
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: .symmetric(
          horizontal: spacing.s12,
          vertical: spacing.s8,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: context.color.borderSubtle),
          borderRadius: .circular(radius.r10),
        ),
        child: Row(
          mainAxisSize: .min,
          children: [
            Icon(
              Icons.camera_alt_outlined,
              size: 14,
              color: context.color.text.secondary,
            ),
            SizedBox(width: spacing.s8),
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
