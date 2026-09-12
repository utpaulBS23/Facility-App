import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../core/utiliity/validation/required_validation.dart';
import '../../../../domain/entities/partner_staff_entity.dart';
import '../../../../domain/entities/problem_category_entity.dart';
import '../../../../domain/entities/report_issue_entity.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/app_text_field.dart';
import 'issue_assign_responsibility_section.dart';
import 'issue_category_selector.dart';
import 'issue_due_date_section.dart';
import 'issue_form_buttons_section.dart';
import 'issue_location_input_section.dart';
import 'issue_photo_picker_section.dart';
import 'issue_priority_selector.dart';
import 'issue_section_label.dart';

class IssueFormFieldsListView extends StatelessWidget {
  const IssueFormFieldsListView({
    super.key,
    required this.titleController,
    required this.locationController,
    required this.selectedCategory,
    required this.categoryError,
    required this.priority,
    required this.photo,
    required this.selectedAttendant,
    required this.dueDate,
    required this.isSubmitting,
    required this.onPickCategory,
    required this.onPriorityChanged,
    required this.onPickCamera,
    required this.onPickGallery,
    required this.onRemovePhoto,
    required this.onPickAttendant,
    required this.onClearAttendant,
    required this.onPickDueDate,
    required this.onClearDueDate,
    required this.onSubmit,
  });

  final TextEditingController titleController;
  final TextEditingController locationController;
  final ProblemCategoryEntity? selectedCategory;
  final bool categoryError;
  final IssuePriority priority;
  final XFile? photo;
  final PartnerStaffEntity? selectedAttendant;
  final DateTime? dueDate;
  final bool isSubmitting;

  final VoidCallback onPickCategory;
  final ValueChanged<IssuePriority> onPriorityChanged;
  final VoidCallback onPickCamera;
  final VoidCallback onPickGallery;
  final VoidCallback onRemovePhoto;
  final VoidCallback onPickAttendant;
  final VoidCallback onClearAttendant;
  final VoidCallback onPickDueDate;
  final VoidCallback onClearDueDate;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return ListView(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.s16,
        vertical: spacing.s20,
      ),
      children: [
        IssueSectionLabel(context.locale.issueTitle),
        Gap(spacing.s8),
        AppTextField.text(
          controller: titleController,
          hint: context.locale.issueTitleHint,
          extraValidations: [RequiredValidation()],
          autovalidateMode: AutovalidateMode.onUserInteraction,
        ),
        Gap(spacing.s16),
        IssueSectionLabel(context.locale.specificProblem),
        Gap(spacing.s8),
        IssueCategorySelector(
          selected: selectedCategory,
          hasError: categoryError,
          onTap: onPickCategory,
        ),
        Gap(spacing.s16),
        IssueSectionLabel(context.locale.location),
        Gap(spacing.s8),
        IssueLocationInputSection(controller: locationController),
        Gap(spacing.s16),
        IssueSectionLabel(context.locale.priority),
        Gap(spacing.s8),
        IssuePrioritySelector(
          selected: priority,
          onChanged: onPriorityChanged,
        ),
        Gap(spacing.s16),
        IssuePhotoPickerSection(
          photo: photo,
          onCamera: onPickCamera,
          onGallery: onPickGallery,
          onRemove: onRemovePhoto,
        ),
        Gap(spacing.s16),
        IssueAssignResponsibilitySection(
          selected: selectedAttendant,
          onTap: onPickAttendant,
          onClear: onClearAttendant,
        ),
        Gap(spacing.s16),
        IssueDueDateSection(
          dueDate: dueDate,
          onTap: onPickDueDate,
          onClear: onClearDueDate,
        ),
        Gap(spacing.s24),
        IssueFormButtonsSection(
          isSubmitting: isSubmitting,
          onSubmit: onSubmit,
        ),
        Gap(spacing.s16),
      ],
    );
  }
}
