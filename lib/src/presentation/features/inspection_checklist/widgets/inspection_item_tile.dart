part of '../view/inspection_checklist_page.dart';

// WHY: intentionally ConsumerWidget — single provider-access point for all tile interactions;
// child widgets are pure StatelessWidgets that receive data and callbacks only.
class _InspectionItemTile extends ConsumerWidget {
  const _InspectionItemTile({
    required this.item,
    required this.state,
    required this.visitId,
    required this.isResolved,
  });

  final ChecklistItemEntity item;
  final InspectionChecklistState state;
  final int visitId;
  final bool isResolved;

  bool get _isAlwaysProof => item.proofPolicy == ChecklistProofPolicy.always;
  bool get _needsProof => item.proofPolicy != ChecklistProofPolicy.none;

  void _onStarTap(WidgetRef ref, int rating) {
    if (_needsProof) {
      ref
          .read(inspectionChecklistProvider.notifier)
          .setStarRatingLocal(itemId: item.id, rating: rating);
    } else {
      ref
          .read(inspectionChecklistProvider.notifier)
          .saveStarRating(visitId: visitId, itemId: item.id, rating: rating);
    }
  }

  void _onYesNo(WidgetRef ref, bool value) {
    if (_needsProof) {
      ref
          .read(inspectionChecklistProvider.notifier)
          .setYesNoLocal(itemId: item.id, value: value);
    } else {
      ref
          .read(inspectionChecklistProvider.notifier)
          .saveYesNo(visitId: visitId, itemId: item.id, value: value);
    }
  }

  void _onSubmitAnswer(WidgetRef ref) {
    ref
        .read(inspectionChecklistProvider.notifier)
        .submitItemAnswer(visitId: visitId, itemId: item.id);
  }

  void _onPickProof(WidgetRef ref) {
    ref
        .read(inspectionChecklistProvider.notifier)
        .pickProofImage(itemId: item.id);
  }

  void _onRemoveProof(WidgetRef ref) {
    ref
        .read(inspectionChecklistProvider.notifier)
        .removeProofImage(itemId: item.id);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = context.dimensions.spacing;
    final isSaving = state.savingItemIds.contains(item.id);
    final saveError = state.itemSaveErrors[item.id];

    final isConfirmed = state.confirmedPoints.containsKey(item.id);
    final hasAnswer = item.answerType == ChecklistAnswerType.star
        ? state.starAnswers.containsKey(item.id)
        : state.yesNoAnswers.containsKey(item.id);
    final hasProofSelected = state.proofImages[item.id]?.isNotEmpty == true;
    final hasProof = hasProofSelected || item.hasProof;
    final photoRequired = item.proofPolicy == ChecklistProofPolicy.always;
    final needsProof = item.proofPolicy != ChecklistProofPolicy.none;

    final showSubmitButton = needsProof;
    final canSubmit =
        hasAnswer && (!photoRequired || hasProof) && !isSaving;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: spacing.s12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ItemOrderBadge(order: item.order),
          SizedBox(width: spacing.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: item.question,
                                    style: context.textStyle.labelLarge.copyWith(
                                      color: context.color.text.primary,
                                    ),
                                  ),
                                  if (!item.isRequired) ...[
                                    TextSpan(text: ' '),
                                    TextSpan(
                                      text: '(${context.locale.optional})',
                                      style: context.textStyle.bodySmall.copyWith(
                                        color: context.color.text.secondary,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isSaving) ...[
                      SizedBox(width: spacing.s8),
                      SizedBox(
                        width: spacing.s14,
                        height: spacing.s14,
                        child: CircularProgressIndicator.adaptive(
                          strokeWidth: 2,
                        ),
                      ),
                    ],
                  ],
                ),
                if (item.isRequired && photoRequired) ...[
                  SizedBox(height: spacing.s8),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: spacing.s12,
                      vertical: spacing.s8,
                    ),
                    decoration: BoxDecoration(
                      color: context.color.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(context.dimensions.radius.r10),
                      border: Border.all(
                        color: context.color.primary.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.lightbulb_outline_rounded,
                          size: 16,
                          color: context.color.primary,
                        ),
                        SizedBox(width: spacing.s8),
                        Expanded(
                          child: BodySmallText(
                            context.locale.updatePhotoAndInputTip,
                            color: context.color.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                SizedBox(height: spacing.s8),
                if (item.answerType == ChecklistAnswerType.star)
                  _StarRatingRow(
                    currentRating: state.starAnswers[item.id] ?? 0,
                    maxPoints: item.maxPoints,
                    onStarTap: isSaving || isResolved
                        ? (_) {}
                        : (r) => _onStarTap(ref, r),
                  )
                else
                  _YesNoRow(
                    answer: state.yesNoAnswers[item.id],
                    onAnswer: isSaving || isResolved
                        ? (_) {}
                        : (v) => _onYesNo(ref, v),
                  ),
                if (item.proofPolicy != ChecklistProofPolicy.none) ...[
                  SizedBox(height: spacing.s8),
                  _ProofAttachmentRow(
                    proofImages: state.proofImages[item.id] ?? [],
                    mediaUrl: state.mediaUrls[item.id],
                    hasExistingProof: item.hasProof,
                    existingMediaUrls: item.existingMediaUrls,
                    onAttach: isResolved ? null : () => _onPickProof(ref),
                    onRemove: isResolved ? null : () => _onRemoveProof(ref),
                  ),
                ],
                if (!isResolved && showSubmitButton) ...[
                  SizedBox(height: spacing.s8),
                  _AnswerSubmitButton(
                    canSubmit: canSubmit,
                    isSaving: isSaving,
                    onTap: canSubmit ? () => _onSubmitAnswer(ref) : null,
                  ),
                ],
                if (saveError != null) ...[
                  SizedBox(height: spacing.s4),
                  BodySmallText(
                    context.locale.saveChecklistAnswerFailed,
                    color: context.color.error,
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

class _AnswerSubmitButton extends StatelessWidget {
  const _AnswerSubmitButton({
    required this.canSubmit,
    required this.isSaving,
    required this.onTap,
  });

  final bool canSubmit;
  final bool isSaving;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    return FilledButton(
      onPressed: canSubmit && !isSaving ? onTap : null,
      style: FilledButton.styleFrom(
        padding: EdgeInsets.symmetric(
          horizontal: spacing.s12,
          vertical: spacing.s6,
        ),
        backgroundColor: context.color.primary,
        disabledBackgroundColor: context.color.primary.withValues(alpha: 0.4),
      ),
      child: isSaving
          ? SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator.adaptive(
                strokeWidth: 2,
              ),
            )
          : BodySmallText(
              context.locale.submitProof,
              color: context.color.onPrimary,
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
        borderRadius: BorderRadius.circular(radius.r6),
      ),
      alignment: Alignment.center,
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
              padding: EdgeInsets.only(right: spacing.s4),
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
  const _YesNoRow({required this.answer, required this.onAnswer});

  final bool? answer;
  final ValueChanged<bool> onAnswer;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Row(
      children: [
        Expanded(
          child: _YesNoChip(
            label: context.locale.yes,
            icon: Icons.check_rounded,
            isSelected: answer == true,
            selectedColor: context.color.success,
            onTap: () => onAnswer(true),
          ),
        ),
        SizedBox(width: spacing.s8),
        Expanded(
          child: _YesNoChip(
            label: context.locale.no,
            icon: Icons.close_rounded,
            isSelected: answer == false,
            selectedColor: context.color.error,
            onTap: () => onAnswer(false),
          ),
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
        padding: EdgeInsets.symmetric(
          horizontal: spacing.s12,
          vertical: spacing.s8,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? selectedColor.withValues(alpha: 0.08)
              : context.color.onPrimary,
          borderRadius: BorderRadius.circular(radius.r12),
          border: Border.all(
            color: isSelected ? selectedColor : context.color.borderSubtle,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: selectedColor),
            SizedBox(width: spacing.s8),
            LabelLargeText(label, color: context.color.text.primary),
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
    this.mediaUrl,
    this.existingMediaUrls = const [],
  });

  final List<XFile> proofImages;
  final String? mediaUrl;
  final bool hasExistingProof;
  final List<String> existingMediaUrls;
  final VoidCallback? onAttach;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final existingUrl = hasExistingProof ? existingMediaUrls.firstOrNull : null;
    final hasAnyProof = proofImages.isNotEmpty || mediaUrl != null || existingUrl != null;
    final isLocked = onAttach == null && onRemove == null;

    if (!hasAnyProof && !isLocked) {
      return OutlinedButton.icon(
        onPressed: onAttach,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(
            horizontal: spacing.s12,
            vertical: spacing.s6,
          ),
        ),
        icon: const Icon(Icons.camera_alt_outlined, size: 14),
        label: BodySmallText(context.locale.attachPhoto),
      );
    }

    // Show photo preview (mediaUrl takes priority, then local proofImages, then existing)
    if (hasAnyProof) {
      final photoPath = proofImages.isNotEmpty ? proofImages.last.path : null;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: context.color.borderSubtle),
                borderRadius: BorderRadius.circular(radius.r10),
              ),
              padding: EdgeInsets.all(spacing.s8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(radius.r6),
                child: photoPath != null
                    ? Image.file(
                        File(photoPath),
                        width: 180,
                        height: 180,
                        fit: BoxFit.cover,
                      )
                    : mediaUrl != null
                        ? Image.network(
                            mediaUrl!,
                            width: 180,
                            height: 180,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 180,
                              height: 180,
                              color: context.color.subtle,
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.image_not_supported_outlined,
                                size: 32,
                                color: context.color.error,
                              ),
                            ),
                          )
                        : existingUrl != null
                            ? Image.network(
                                existingUrl,
                                width: 180,
                                height: 180,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  width: 180,
                                  height: 180,
                                  color: context.color.subtle,
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.image_not_supported_outlined,
                                    size: 32,
                                    color: context.color.error,
                                  ),
                                ),
                              )
                            : Container(
                                width: 180,
                                height: 180,
                                color: context.color.subtle,
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.check_circle_outline,
                                  size: 32,
                                  color: context.color.success,
                                ),
                              ),
              ),
            ),
          ),
          if (!isLocked && (proofImages.isNotEmpty || mediaUrl != null || existingUrl != null)) ...[
            SizedBox(height: spacing.s8),
            Wrap(
              spacing: spacing.s16,
              runSpacing: spacing.s8,
              children: [
                OutlinedButton.icon(
                  onPressed: onAttach,
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: spacing.s12,
                      vertical: spacing.s6,
                    ),
                  ),
                  icon: const Icon(Icons.edit_outlined, size: 14),
                  label: BodySmallText(context.locale.edit),
                ),
                if (proofImages.isNotEmpty)
                  OutlinedButton.icon(
                    onPressed: onRemove,
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: spacing.s12,
                        vertical: spacing.s6,
                      ),
                    ),
                    icon: const Icon(Icons.delete_outline_rounded, size: 14),
                    label: BodySmallText(context.locale.remove),
                  ),
              ],
            ),
          ],
        ],
      );
    }

    return const SizedBox.shrink();
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
      padding: EdgeInsets.symmetric(
        horizontal: spacing.s12,
        vertical: spacing.s8,
      ),
      decoration: BoxDecoration(
        color: context.color.successAlt,
        borderRadius: BorderRadius.circular(radius.r10),
        border: Border.all(color: context.color.success),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.camera_alt_outlined,
            size: 14,
            color: context.color.success,
          ),
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
            alignment: Alignment.center,
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
        padding: EdgeInsets.symmetric(
          horizontal: spacing.s12,
          vertical: spacing.s8,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: context.color.borderSubtle),
          borderRadius: BorderRadius.circular(radius.r10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
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
          border: Border.all(color: context.color.primary, width: 1.5),
        ),
        alignment: Alignment.center,
        child: Icon(
          Icons.delete_outline_rounded,
          size: 16,
          color: context.color.primary,
        ),
      ),
    );
  }
}

class _MediaThumbnailRow extends StatelessWidget {
  const _MediaThumbnailRow({required this.urls});

  final List<String> urls;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;

    return Center(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: context.color.borderSubtle),
          borderRadius: BorderRadius.circular(radius.r10),
        ),
        padding: EdgeInsets.all(spacing.s8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius.r6),
          child: Image.network(
            urls.first,
            width: 180,
            height: 180,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Container(
              width: 180,
              height: 180,
              color: context.color.subtle,
              alignment: Alignment.center,
              child: Icon(
                Icons.broken_image_outlined,
                size: 32,
                color: context.color.text.secondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
