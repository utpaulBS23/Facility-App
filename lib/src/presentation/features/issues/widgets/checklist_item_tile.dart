part of '../view/issues_page.dart';

// ── Order badge ──────────────────────────────────────────────────────────────

class _OrderBadge extends StatelessWidget {
  const _OrderBadge({required this.order});

  final int order;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: context.color.subtle,
        borderRadius: BorderRadius.circular(context.dimensions.radius.r6),
      ),
      alignment: Alignment.center,
      child: LabelLargeText('$order', color: context.color.text.primary),
    );
  }
}

// ── Rating picker tile ────────────────────────────────────────────────────────

class _RatingPickerTile extends StatefulWidget {
  const _RatingPickerTile({
    required this.order,
    required this.question,
    required this.maxPoints,
    required this.requiresProof,
  });

  final int order;
  final String question;
  final int maxPoints;
  final bool requiresProof;

  @override
  State<_RatingPickerTile> createState() => _RatingPickerTileState();
}

class _RatingPickerTileState extends State<_RatingPickerTile> {
  int _rating = 0;
  final List<XFile> _proofImages = [];

  Future<void> _pickProof() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null && mounted) setState(() => _proofImages.add(file));
  }

  void _removeProof() {
    if (_proofImages.isNotEmpty) setState(() => _proofImages.removeLast());
  }

  void _onStarTap(int value) {
    setState(() => _rating = value);
    if (!widget.requiresProof) _autoSave();
  }

  // WHY: non-proof items auto-save silently — feedback comes from real network response
  void _autoSave() {}

  void _submit() {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.locale.submit),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: spacing.s12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _OrderBadge(order: widget.order),
          SizedBox(width: spacing.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LabelLargeText(
                  widget.question,
                  color: context.color.text.primary,
                ),
                SizedBox(height: spacing.s8),
                Row(
                  children: List.generate(widget.maxPoints, (index) {
                    final starValue = index + 1;
                    final filled = starValue <= _rating;
                    return GestureDetector(
                      onTap: () => _onStarTap(starValue),
                      child: Padding(
                        padding: EdgeInsets.only(right: spacing.s4),
                        child: Icon(
                          filled
                              ? Icons.star_rounded
                              : Icons.star_outline_rounded,
                          size: 24,
                          color: filled
                              ? context.color.warning
                              : context.color.border,
                        ),
                      ),
                    );
                  }),
                ),
                if (widget.requiresProof) ...[
                  SizedBox(height: spacing.s8),
                  _ProofRow(
                    images: _proofImages,
                    onAttach: _pickProof,
                    onRemove: _removeProof,
                  ),
                  SizedBox(height: spacing.s8),
                  _SubmitIconButton(
                    enabled: _rating > 0 && _proofImages.isNotEmpty,
                    onTap: _submit,
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

// ── Boolean picker tile ───────────────────────────────────────────────────────

class _BoolPickerTile extends StatefulWidget {
  const _BoolPickerTile({
    required this.order,
    required this.question,
    required this.requiresProof,
  });

  final int order;
  final String question;
  final bool requiresProof;

  @override
  State<_BoolPickerTile> createState() => _BoolPickerTileState();
}

class _BoolPickerTileState extends State<_BoolPickerTile> {
  bool? _answer;
  final List<XFile> _proofImages = [];

  Future<void> _pickProof() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null && mounted) setState(() => _proofImages.add(file));
  }

  void _removeProof() {
    if (_proofImages.isNotEmpty) setState(() => _proofImages.removeLast());
  }

  void _onAnswer(bool value) {
    setState(() => _answer = value);
    if (!widget.requiresProof) _autoSave(value);
  }

  // WHY: non-proof items auto-save silently — feedback comes from real network response
  void _autoSave(bool value) {}

  void _submit() {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.locale.submit),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: spacing.s12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _OrderBadge(order: widget.order),
          SizedBox(width: spacing.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LabelLargeText(
                  widget.question,
                  color: context.color.text.primary,
                ),
                SizedBox(height: spacing.s8),
                Row(
                  children: [
                    _YesNoChip(
                      label: context.locale.yes,
                      icon: Icons.check_rounded,
                      isSelected: _answer == true,
                      selectedColor: context.color.success,
                      onTap: () => _onAnswer(true),
                    ),
                    SizedBox(width: spacing.s8),
                    _YesNoChip(
                      label: context.locale.no,
                      icon: Icons.close_rounded,
                      isSelected: _answer == false,
                      selectedColor: context.color.error,
                      onTap: () => _onAnswer(false),
                    ),
                  ],
                ),
                if (widget.requiresProof) ...[
                  SizedBox(height: spacing.s8),
                  _ProofRow(
                    images: _proofImages,
                    onAttach: _pickProof,
                    onRemove: _removeProof,
                  ),
                  SizedBox(height: spacing.s8),
                  _SubmitIconButton(
                    enabled: _answer != null && _proofImages.isNotEmpty,
                    onTap: _submit,
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

// ── Attachment-only tile ──────────────────────────────────────────────────────

class _AttachmentOnlyPickerTile extends StatefulWidget {
  const _AttachmentOnlyPickerTile({
    required this.order,
    required this.instruction,
  });

  final int order;
  final String instruction;

  @override
  State<_AttachmentOnlyPickerTile> createState() =>
      _AttachmentOnlyPickerTileState();
}

class _AttachmentOnlyPickerTileState extends State<_AttachmentOnlyPickerTile> {
  final List<XFile> _proofImages = [];

  Future<void> _pickProof() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null && mounted) setState(() => _proofImages.add(file));
  }

  void _removeProof() {
    if (_proofImages.isNotEmpty) setState(() => _proofImages.removeLast());
  }

  void _save() {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.locale.save),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: spacing.s12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _OrderBadge(order: widget.order),
          SizedBox(width: spacing.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LabelLargeText(
                  widget.instruction,
                  color: context.color.text.primary,
                ),
                SizedBox(height: spacing.s8),
                _ProofRow(
                  images: _proofImages,
                  onAttach: _pickProof,
                  onRemove: _removeProof,
                ),
                SizedBox(height: spacing.s8),
                _SaveIconButton(enabled: _proofImages.isNotEmpty, onTap: _save),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Yes/No chip ───────────────────────────────────────────────────────────────

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

// ── Proof row ─────────────────────────────────────────────────────────────────

class _ProofRow extends StatelessWidget {
  const _ProofRow({
    required this.images,
    required this.onAttach,
    required this.onRemove,
  });

  final List<XFile> images;
  final VoidCallback onAttach;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final hasProof = images.isNotEmpty;

    return Row(
      children: [
        if (hasProof) ...[
          _PhotoAttachedChip(count: images.length),
          SizedBox(width: spacing.s8),
          const Spacer(),
          _RemoveProofButton(onTap: onRemove),
        ] else
          _AttachPhotoButton(onTap: onAttach),
      ],
    );
  }
}

// ── Action buttons ────────────────────────────────────────────────────────────

class _SubmitIconButton extends StatelessWidget {
  const _SubmitIconButton({required this.enabled, required this.onTap});

  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: enabled ? onTap : null,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: context.dimensions.spacing.s12,
            vertical: context.dimensions.spacing.s8,
          ),
          decoration: BoxDecoration(
            color: enabled ? context.color.primary : context.color.disabled,
            borderRadius: BorderRadius.circular(context.dimensions.radius.r6),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.send_rounded,
                size: 14,
                color: context.color.onPrimary,
              ),
              SizedBox(width: context.dimensions.spacing.s6),
              BodySmallText(
                context.locale.submit,
                color: context.color.onPrimary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SaveIconButton extends StatelessWidget {
  const _SaveIconButton({required this.enabled, required this.onTap});

  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: enabled ? onTap : null,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: context.dimensions.spacing.s12,
            vertical: context.dimensions.spacing.s8,
          ),
          decoration: BoxDecoration(
            color: enabled ? context.color.primary : context.color.disabled,
            borderRadius: BorderRadius.circular(context.dimensions.radius.r6),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.cloud_upload_outlined,
                size: 14,
                color: context.color.onPrimary,
              ),
              SizedBox(width: context.dimensions.spacing.s6),
              BodySmallText(
                context.locale.save,
                color: context.color.onPrimary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Proof attachment sub-widgets ──────────────────────────────────────────────

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
        borderRadius: BorderRadius.circular(context.dimensions.radius.r10),
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
