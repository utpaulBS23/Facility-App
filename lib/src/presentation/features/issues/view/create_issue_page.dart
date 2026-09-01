import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../core/utiliity/validation/required_validation.dart';
import '../../../../domain/entities/partner_staff_entity.dart';
import '../../../../domain/entities/problem_category_entity.dart';
import '../../../../domain/entities/report_issue_entity.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/detail_app_bar.dart';
import '../../../core/widgets/filter_chip_group.dart';
import '../../../core/widgets/text/typography.dart';
import '../riverpod/create_issue_provider.dart';

class CreateIssuePage extends ConsumerStatefulWidget {
  const CreateIssuePage({
    super.key,
    required this.visitId,
    required this.facilityId,
    required this.facilityName,
  });

  final int visitId;
  final int facilityId;
  final String facilityName;

  @override
  ConsumerState<CreateIssuePage> createState() => _CreateIssuePageState();
}

class _CreateIssuePageState extends ConsumerState<CreateIssuePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _locationController;
  late final TextEditingController _titleController;

  ProblemCategoryEntity? _selectedCategory;
  bool _categoryError = false;
  IssuePriority _priority = IssuePriority.medium;
  XFile? _photo;
  PartnerStaffEntity? _selectedAttendant;

  @override
  void initState() {
    super.initState();
    _locationController = TextEditingController(text: widget.facilityName);
    _titleController = TextEditingController();
  }

  @override
  void dispose() {
    _locationController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _onPickCamera() async {
    final file = await ImagePicker().pickImage(source: ImageSource.camera);
    if (file != null) setState(() => _photo = file);
  }

  Future<void> _onPickGallery() async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file != null) setState(() => _photo = file);
  }

  void _onRemovePhoto() => setState(() => _photo = null);

  Future<void> _onPickAttendant() async {
    final result = await showModalBottomSheet<PartnerStaffEntity>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AttendantPickerSheet(facilityId: widget.facilityId),
    );
    if (result != null) setState(() => _selectedAttendant = result);
  }

  void _onClearAttendant() => setState(() => _selectedAttendant = null);

  Future<void> _onPickCategory() async {
    final partnerId = ref.read(createIssueProvider.notifier).partnerId;
    final result = await showModalBottomSheet<ProblemCategoryEntity>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CategoryPickerSheet(
        partnerId: partnerId,
        selected: _selectedCategory,
      ),
    );
    if (result != null) {
      setState(() {
        _selectedCategory = result;
        _categoryError = false;
      });
    }
  }

  Future<void> _onSubmit() async {
    final categoryOk = _selectedCategory != null;
    setState(() => _categoryError = !categoryOk);
    if (!_formKey.currentState!.validate() || !categoryOk) return;

    await ref
        .read(createIssueProvider.notifier)
        .submit(
          request: ReportIssueRequestEntity(
            visitId: widget.visitId,
            categoryValue: _selectedCategory!.value,
            title: _titleController.text.trim(),
            priority: _priority,
            photoPath: _photo?.path,
            assignedTo: _selectedAttendant?.id,
          ),
          categoryName: _selectedCategory!.name,
          facilityName: widget.facilityName,
        );

    if (!mounted) return;
    final issueState = ref.read(createIssueProvider);
    if (issueState.createdIssue != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.locale.issueReportedSuccessfully),
          backgroundColor: context.color.success,
        ),
      );
      context.pop(issueState.createdIssue);
    } else if (issueState.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(issueState.error!),
          backgroundColor: context.color.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final submitState = ref.watch(createIssueProvider);

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: DetailAppBar(title: context.locale.createIssue),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: spacing.s16,
            vertical: spacing.s20,
          ),
          children: [
            _SectionLabel(context.locale.issueTitle),
            Gap(spacing.s8),
            AppTextField.text(
              controller: _titleController,
              hint: context.locale.issueTitleHint,
              extraValidations: [RequiredValidation()],
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
            Gap(spacing.s16),
            _SectionLabel(context.locale.specificProblem),
            Gap(spacing.s8),
            _CategorySelector(
              selected: _selectedCategory,
              hasError: _categoryError,
              onTap: _onPickCategory,
            ),
            Gap(spacing.s16),
            _SectionLabel(context.locale.location),
            Gap(spacing.s8),
            IgnorePointer(
              child: AppTextField.text(
                controller: _locationController,
                hint: context.locale.location,
                prefixIcon: Icon(
                  Icons.location_on_outlined,
                  color: context.color.text.secondary,
                ),
              ),
            ),
            Gap(spacing.s16),
            _SectionLabel(context.locale.priority),
            Gap(spacing.s8),
            _PrioritySelector(
              selected: _priority,
              onChanged: (p) => setState(() => _priority = p),
            ),
            Gap(spacing.s16),
            _PhotoPickerSection(
              photo: _photo,
              onCamera: _onPickCamera,
              onGallery: _onPickGallery,
              onRemove: _onRemovePhoto,
            ),
            Gap(spacing.s16),
            _AssignResponsibilitySection(
              selected: _selectedAttendant,
              onTap: _onPickAttendant,
              onClear: _onClearAttendant,
            ),
            Gap(spacing.s24),
            FilledButton(
              onPressed: submitState.isSubmitting ? null : _onSubmit,
              style: FilledButton.styleFrom(
                backgroundColor: context.color.primary,
                disabledBackgroundColor: context.color.primary.withValues(
                  alpha: 0.4,
                ),
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    context.dimensions.radius.r12,
                  ),
                ),
              ),
              child: submitState.isSubmitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator.adaptive(strokeWidth: 2),
                    )
                  : Text(
                      context.locale.submitRequest,
                      style: context.textStyle.labelLarge.copyWith(
                        color: context.color.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
            Gap(spacing.s12),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: TextButton(
                onPressed: () => context.pop(),
                style: TextButton.styleFrom(
                  backgroundColor: context.color.subtle,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      context.dimensions.radius.r12,
                    ),
                  ),
                ),
                child: Text(
                  context.locale.cancel,
                  style: context.textStyle.labelLarge.copyWith(
                    color: context.color.text.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Gap(spacing.s16),
          ],
        ),
      ),
    );
  }
}

class _CategorySelector extends StatelessWidget {
  const _CategorySelector({
    required this.selected,
    required this.hasError,
    required this.onTap,
  });

  final ProblemCategoryEntity? selected;
  final bool hasError;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final radius = context.dimensions.radius;
    final spacing = context.dimensions.spacing;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 52,
            decoration: BoxDecoration(
              border: Border.all(
                color: hasError
                    ? context.color.error
                    : context.color.borderSubtle,
              ),
              borderRadius: BorderRadius.circular(radius.r6),
            ),
            padding: EdgeInsets.symmetric(horizontal: spacing.s16),
            child: Row(
              children: [
                Expanded(
                  child: BodyRegularText(
                    selected?.name ?? context.locale.specificProblemHint,
                    color: selected != null
                        ? context.color.text.primary
                        : context.color.text.secondary,
                  ),
                ),
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
          Padding(
            padding: EdgeInsets.only(left: spacing.s4),
            child: BodySmallText(
              context.locale.fieldRequired,
              color: context.color.error,
            ),
          ),
        ],
      ],
    );
  }
}

// WHY chip group + Apply, not tap-to-select-and-pop: mirrors the
// attendance filter sheet's single-field layout (see
// FilterChipGroup/attendance_filter_sheet.dart) so every chip-based picker
// in the app behaves and looks the same.
class _CategoryPickerSheet extends ConsumerStatefulWidget {
  const _CategoryPickerSheet({required this.partnerId, this.selected});

  final int partnerId;
  final ProblemCategoryEntity? selected;

  @override
  ConsumerState<_CategoryPickerSheet> createState() =>
      _CategoryPickerSheetState();
}

class _CategoryPickerSheetState extends ConsumerState<_CategoryPickerSheet> {
  late String? _selectedValue = widget.selected?.value;
  List<ProblemCategoryEntity> _categories = const [];

  // WHY comparing by `value` (String key), not the entity itself: the
  // provider is autoDispose, so a rebuild can hand back a fresh list of
  // ProblemCategoryEntity instances for the same categories — comparing
  // objects directly would silently drop the chip's selected state.
  void _onApply() {
    final selected = _categories
        .cast<ProblemCategoryEntity?>()
        .firstWhere((cat) => cat?.value == _selectedValue, orElse: () => null);
    Navigator.of(context).pop(selected);
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final categoriesAsync = ref.watch(
      problemCategoriesProvider(widget.partnerId),
    );

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.75,
      ),
      decoration: BoxDecoration(
        color: context.color.scaffoldBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(radius.r12)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Gap(spacing.s12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: context.color.borderSubtle,
              borderRadius: BorderRadius.circular(radius.r4),
            ),
          ),
          Gap(spacing.s16),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: spacing.s16),
            child: LabelLargeText(context.locale.specificProblem),
          ),
          Gap(spacing.s16),
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: spacing.s16),
              child: categoriesAsync.when(
                loading: () =>
                    const Center(child: CircularProgressIndicator.adaptive()),
                error: (_, _) => Center(
                  child: BodySmallText(
                    context.locale.reportIssueFailed,
                    color: context.color.error,
                  ),
                ),
                data: (categories) {
                  _categories = categories;
                  if (categories.isEmpty) {
                    return Center(
                      child: BodySmallText(
                        context.locale.noProblemCategoriesFound,
                        color: context.color.text.secondary,
                      ),
                    );
                  }
                  return FilterChipGroup<String?>(
                    label: context.locale.specificProblem,
                    selected: _selectedValue,
                    options: [
                      for (final category in categories)
                        (value: category.value, label: category.name),
                    ],
                    onSelected: (value) =>
                        setState(() => _selectedValue = value),
                  );
                },
              ),
            ),
          ),
          Gap(spacing.s16),
          Padding(
            padding: EdgeInsets.fromLTRB(
              spacing.s16,
              0,
              spacing.s16,
              spacing.s16,
            ),
            child: SizedBox(
              width: double.infinity,
              height: spacing.s44,
              child: FilledButton(
                onPressed: _onApply,
                child: Text(context.locale.applyFilters),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) =>
      LabelLargeText(text, color: context.color.text.primary);
}

class _PrioritySelector extends StatelessWidget {
  const _PrioritySelector({required this.selected, required this.onChanged});

  final IssuePriority selected;
  final ValueChanged<IssuePriority> onChanged;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Row(
      children: IssuePriority.values.map((p) {
        final isLast = p == IssuePriority.values.last;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: isLast ? 0 : spacing.s8),
            child: _PriorityChip(
              label: _label(context, p),
              isSelected: p == selected,
              onTap: () => onChanged(p),
            ),
          ),
        );
      }).toList(),
    );
  }

  String _label(BuildContext context, IssuePriority p) => switch (p) {
    IssuePriority.high => context.locale.priorityHigh,
    IssuePriority.medium => context.locale.priorityMedium,
    IssuePriority.normal => context.locale.priorityNormal,
    IssuePriority.low => context.locale.priorityLow,
  };
}

class _PriorityChip extends StatelessWidget {
  const _PriorityChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final radius = context.dimensions.radius;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 40,
        decoration: BoxDecoration(
          color: isSelected
              ? context.color.primary.withValues(alpha: 0.08)
              : context.color.onPrimary,
          borderRadius: BorderRadius.circular(radius.r6),
          border: Border.all(
            color: isSelected
                ? context.color.primary
                : context.color.borderSubtle,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        alignment: Alignment.center,
        child: BodySmallText(
          label,
          color: isSelected
              ? context.color.primary
              : context.color.text.secondary,
        ),
      ),
    );
  }
}

class _PhotoPickerSection extends StatelessWidget {
  const _PhotoPickerSection({
    required this.photo,
    required this.onCamera,
    required this.onGallery,
    required this.onRemove,
  });

  final XFile? photo;
  final VoidCallback onCamera;
  final VoidCallback onGallery;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;

    return Container(
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: context.color.onPrimary,
        borderRadius: BorderRadius.circular(radius.r12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LabelLargeText(context.locale.photoOptional),
          Gap(spacing.s12),
          if (photo != null) ...[
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(radius.r6),
                  child: Image.file(
                    File(photo!.path),
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: spacing.s8,
                  right: spacing.s8,
                  child: GestureDetector(
                    onTap: onRemove,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: context.color.onPrimary,
                        shape: BoxShape.circle,
                        border: Border.all(color: context.color.error),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.close_rounded,
                        size: 14,
                        color: context.color.error,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: onCamera,
                    icon: const Icon(Icons.camera_alt_outlined, size: 20),
                    label: Text(context.locale.camera),
                    style: FilledButton.styleFrom(
                      backgroundColor: context.color.primary,
                      foregroundColor: context.color.onPrimary,
                      minimumSize: const Size.fromHeight(52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(radius.r12),
                      ),
                      textStyle: context.textStyle.labelLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Gap(spacing.s12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onGallery,
                    icon: Icon(
                      Icons.image_outlined,
                      size: 20,
                      color: context.color.primary,
                    ),
                    label: Text(context.locale.gallery),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: context.color.primary,
                      side: BorderSide(
                        color: context.color.primary,
                        width: 1.5,
                      ),
                      minimumSize: const Size.fromHeight(52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(radius.r12),
                      ),
                      textStyle: context.textStyle.labelLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _AssignResponsibilitySection extends StatelessWidget {
  const _AssignResponsibilitySection({
    required this.selected,
    required this.onTap,
    required this.onClear,
  });

  final PartnerStaffEntity? selected;
  final VoidCallback onTap;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(spacing.s16),
        decoration: BoxDecoration(
          color: context.color.onPrimary,
          borderRadius: BorderRadius.circular(radius.r12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (selected == null)
              BodySmallText(
                context.locale.noResponsibilityAdded,
                color: context.color.text.secondary,
              )
            else
              BodySmallText(
                context.locale.assignResponsibility,
                color: context.color.text.secondary,
              ),
            Gap(spacing.s12),
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: selected != null
                      ? context.color.primary
                      : context.color.brandAccent,
                  child: Icon(
                    selected != null
                        ? Icons.check_rounded
                        : Icons.person_outline_rounded,
                    size: 18,
                    color: selected != null
                        ? context.color.onPrimary
                        : context.color.text.primary,
                  ),
                ),
                Gap(spacing.s8),
                Expanded(
                  child: selected != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LabelLargeText(selected!.name),
                            Gap(spacing.s2),
                            BodySmallText(
                              selected!.phoneNumber ?? selected!.email,
                              color: context.color.text.secondary,
                            ),
                          ],
                        )
                      : LabelLargeText(context.locale.assignResponsibility),
                ),
                if (selected != null)
                  GestureDetector(
                    onTap: onClear,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: context.color.error),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.close_rounded,
                        size: 14,
                        color: context.color.error,
                      ),
                    ),
                  )
                else
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: context.color.primary,
                            width: 1.5,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.add_rounded,
                          size: 18,
                          color: context.color.primary,
                        ),
                      ),
                      Gap(spacing.s6),
                      LabelLargeText(
                        context.locale.add,
                        color: context.color.primary,
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AttendantPickerSheet extends ConsumerWidget {
  const _AttendantPickerSheet({required this.facilityId});

  final int facilityId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final attendantsAsync = ref.watch(issueAttendantsProvider(facilityId));

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.75,
      ),
      decoration: BoxDecoration(
        color: context.color.scaffoldBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(radius.r12)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Gap(spacing.s12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: context.color.borderSubtle,
              borderRadius: BorderRadius.circular(context.dimensions.radius.r4),
            ),
          ),
          Gap(spacing.s16),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: spacing.s16),
            child: LabelLargeText(context.locale.assignResponsibility),
          ),
          Gap(spacing.s16),
          Flexible(
            child: attendantsAsync.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator.adaptive()),
              error: (err, _) => Center(
                child: BodySmallText(
                  err.toString(),
                  color: context.color.error,
                ),
              ),
              data: (attendants) {
                if (attendants.isEmpty) {
                  return Center(
                    child: BodySmallText(
                      context.locale.noAttendantsFound,
                      color: context.color.text.secondary,
                    ),
                  );
                }
                return ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.fromLTRB(
                    spacing.s16,
                    0,
                    spacing.s16,
                    spacing.s16,
                  ),
                  itemCount: attendants.length,
                  separatorBuilder: (_, _) => Gap(spacing.s12),
                  itemBuilder: (context, index) {
                    final attendant = attendants[index];
                    return _AttendantPickerTile(
                      attendant: attendant,
                      onTap: () => Navigator.of(context).pop(attendant),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _AttendantPickerTile extends StatelessWidget {
  const _AttendantPickerTile({required this.attendant, required this.onTap});

  final PartnerStaffEntity attendant;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(spacing.s16),
        decoration: BoxDecoration(
          color: context.color.onPrimary,
          border: Border.all(color: context.color.borderSubtle),
          borderRadius: BorderRadius.circular(radius.r12),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: context.color.brandAccent,
              child: Icon(
                Icons.person_outline_rounded,
                color: context.color.text.primary,
                size: 22,
              ),
            ),
            Gap(spacing.s12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LabelLargeText(attendant.name),
                  Gap(spacing.s2),
                  BodySmallText(
                    attendant.phoneNumber ?? attendant.email,
                    color: context.color.text.secondary,
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: spacing.s8,
                vertical: spacing.s4,
              ),
              decoration: BoxDecoration(
                color: attendant.isActive
                    ? context.color.successAlt
                    : context.color.warningAlt,
                borderRadius: BorderRadius.circular(radius.r4),
              ),
              child: BodySmallText(
                attendant.userRole ?? context.locale.status,
                color: attendant.isActive
                    ? context.color.success
                    : context.color.warning,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
