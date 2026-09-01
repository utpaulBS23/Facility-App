part of '../view/occurrence_checklist_page.dart';

class _ChecklistItemForm extends ConsumerStatefulWidget {
  const _ChecklistItemForm({
    super.key,
    required this.occurrenceId,
    required this.item,
    required this.order,
    this.readOnly = false,
  });

  final int occurrenceId;
  final TaskOccurrenceChecklistItemEntity item;
  final int order;
  final bool readOnly;

  @override
  ConsumerState<_ChecklistItemForm> createState() => _ChecklistItemFormState();
}

class _ChecklistItemFormState extends ConsumerState<_ChecklistItemForm> {
  final _picker = ImagePicker();
  late final TextEditingController _textController;
  int? _ratingValue;
  bool? _booleanValue;
  XFile? _photo;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final response = widget.item.response;
    _textController = TextEditingController(text: response?.textValue ?? '');
    _ratingValue = response?.ratingValue;
    _booleanValue = response?.booleanValue;
  }

  @override
  void didUpdateWidget(covariant _ChecklistItemForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.item != widget.item) {
      final response = widget.item.response;
      if (_textController.text != (response?.textValue ?? '')) {
        _textController.text = response?.textValue ?? '';
      }
      _ratingValue = response?.ratingValue;
      _booleanValue = response?.booleanValue;
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    final photo = await _picker.pickImage(source: ImageSource.camera, imageQuality: 85);
    if (photo == null || !mounted) return;
    setState(() => _photo = photo);
  }

  bool get _hasAnswer => switch (widget.item.responseType) {
    TaskOccurrenceChecklistResponseType.rating => _ratingValue != null,
    TaskOccurrenceChecklistResponseType.boolean => _booleanValue != null,
    TaskOccurrenceChecklistResponseType.text => _textController.text.trim().isNotEmpty,
  };

  Future<void> _save() async {
    if (!_hasAnswer) return;
    setState(() => _isSaving = true);

    final result = await ref
        .read(taskOccurrenceChecklistAnswerProvider.notifier)
        .answer(
          taskOccurrenceId: widget.occurrenceId,
          itemId: widget.item.id,
          ratingValue: widget.item.responseType == TaskOccurrenceChecklistResponseType.rating
              ? _ratingValue
              : null,
          booleanValue: widget.item.responseType == TaskOccurrenceChecklistResponseType.boolean
              ? _booleanValue
              : null,
          textValue: widget.item.responseType == TaskOccurrenceChecklistResponseType.text
              ? _textController.text.trim()
              : null,
          photoPath: _photo?.path,
        );

    if (!mounted) return;
    setState(() => _isSaving = false);
    result.when(
      success: (_) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.locale.occurrenceAnswerSaved)),
      ),
      error: (error) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.localized(context))),
      ),
    );
  }

  Widget _photoSection(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final hasSavedPhoto =
        widget.item.isAnswered && (widget.item.response?.hasProof ?? false);

    if (!hasSavedPhoto) {
      return Expanded(
        child: GestureDetector(
          onTap: _isSaving || widget.readOnly ? null : _pickPhoto,
          child: Container(
            padding: .symmetric(horizontal: spacing.s12, vertical: spacing.s10),
            decoration: BoxDecoration(
              border: Border.all(color: context.color.borderSubtle),
              borderRadius: .circular(radius.r10),
            ),
            child: Row(
              mainAxisAlignment: .center,
              children: [
                Icon(
                  _photo != null
                      ? Icons.check_circle_outline
                      : Icons.camera_alt_outlined,
                  size: 16,
                  color: _photo != null ? context.color.success : context.color.text.secondary,
                ),
                Gap(spacing.s8),
                Flexible(
                  child: BodySmallText(
                    _photo != null ? context.locale.changePhoto : context.locale.takePhoto,
                    color: context.color.text.secondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final mediaUrl = widget.item.response?.mediaUrl;
    return ClipRRect(
      borderRadius: .circular(radius.r6),
      child: _photo != null
          ? Image.file(
              File(_photo!.path),
              width: spacing.s56,
              height: spacing.s56,
              fit: .cover,
            )
          : mediaUrl != null
          ? Image.network(
              mediaUrl,
              width: spacing.s56,
              height: spacing.s56,
              fit: .cover,
              errorBuilder: (_, _, _) => _lockedPhotoChip(context),
            )
          : _lockedPhotoChip(context),
    );
  }

  Widget _lockedPhotoChip(BuildContext context) {
    final spacing = context.dimensions.spacing;
    return Container(
      width: spacing.s56,
      height: spacing.s56,
      color: context.color.subtle,
      alignment: .center,
      child: Icon(Icons.check_circle_outline, color: context.color.success),
    );
  }

  Widget _answerInput(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final isDisabled = _isSaving || widget.readOnly;
    return switch (widget.item.responseType) {
      TaskOccurrenceChecklistResponseType.rating => Row(
        children: List.generate(5, (i) {
          final value = i + 1;
          final isFilled = (_ratingValue ?? 0) >= value;
          return GestureDetector(
            onTap: isDisabled ? null : () => setState(() => _ratingValue = value),
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: .only(right: spacing.s8),
              child: Icon(
                isFilled ? Icons.star_rounded : Icons.star_border_rounded,
                size: 32,
                color: isFilled ? context.color.warning : context.color.border,
              ),
            ),
          );
        }),
      ),
      TaskOccurrenceChecklistResponseType.boolean => Row(
        children: [
          Expanded(
            child: _BooleanChoiceChip(
              label: context.locale.occurrenceYes,
              icon: Icons.check_rounded,
              isSelected: _booleanValue == true,
              color: context.color.success,
              onTap: isDisabled ? null : () => setState(() => _booleanValue = true),
            ),
          ),
          Gap(spacing.s8),
          Expanded(
            child: _BooleanChoiceChip(
              label: context.locale.occurrenceNo,
              icon: Icons.close_rounded,
              isSelected: _booleanValue == false,
              color: context.color.error,
              onTap: isDisabled ? null : () => setState(() => _booleanValue = false),
            ),
          ),
        ],
      ),
      TaskOccurrenceChecklistResponseType.text => TextField(
        controller: _textController,
        enabled: !isDisabled,
        maxLines: 3,
        decoration: InputDecoration(labelText: context.locale.occurrenceTextAnswerLabel),
        onChanged: (_) => setState(() {}),
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final isAnswered = widget.item.isAnswered;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      padding: .all(spacing.s16),
      decoration: BoxDecoration(
        color: context.color.onPrimary,
        border: Border.all(
          color: isAnswered ? context.color.success : context.color.borderSubtle,
          width: isAnswered ? 1.5 : 1,
        ),
        borderRadius: .circular(radius.r12),
      ),
      child: Column(
        mainAxisSize: .min,
        crossAxisAlignment: .start,
        children: [
          Row(
            crossAxisAlignment: .start,
            children: [
              _ItemOrderBadge(order: widget.order),
              Gap(spacing.s12),
              Expanded(child: LabelLargeText(widget.item.label)),
              if (isAnswered)
                Icon(Icons.check_circle_rounded, size: 18, color: context.color.success),
            ],
          ),
          Gap(spacing.s12),
          _answerInput(context),
          Gap(spacing.s12),
          Row(
            children: [
              _photoSection(context),
              Gap(spacing.s8),
              Expanded(
                child: FilledButton(
                  onPressed: _isSaving || !_hasAnswer || widget.readOnly
                      ? null
                      : _save,
                  child: _isSaving
                      ? SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: context.color.onPrimary,
                          ),
                        )
                      : Text(context.locale.occurrenceSaveAnswer),
                ),
              ),
            ],
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

class _BooleanChoiceChip extends StatelessWidget {
  const _BooleanChoiceChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: .symmetric(horizontal: spacing.s12, vertical: spacing.s10),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.08) : context.color.onPrimary,
          borderRadius: .circular(radius.r10),
          border: Border.all(
            color: isSelected ? color : context.color.borderSubtle,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: .center,
          mainAxisSize: .min,
          children: [
            Icon(icon, size: 16, color: isSelected ? color : context.color.text.secondary),
            Gap(spacing.s8),
            Text(
              label,
              style: context.textStyle.bodyMedium.copyWith(
                color: isSelected ? color : context.color.text.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
