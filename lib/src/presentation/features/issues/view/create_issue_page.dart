import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/extensions/app_localization.dart';
import '../../../../core/extensions/failure_localization.dart';
import '../../../../domain/entities/master_data_entity.dart';
import '../../../../domain/entities/partner_staff_entity.dart';
import '../../../../domain/entities/problem_category_entity.dart';
import '../../../../domain/entities/report_issue_entity.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/detail_app_bar.dart';

import '../riverpod/create_issue_provider.dart';
import '../widgets/issue_attendant_picker_sheet.dart';
import '../widgets/issue_category_picker_sheet.dart';
import '../widgets/issue_form_fields_list_view.dart';

class CreateIssuePage extends ConsumerStatefulWidget {
  const CreateIssuePage({
    super.key,
    required this.visitId,
    required this.facilityId,
    required this.facilityName,
    this.issue,
  });

  final int visitId;
  final int facilityId;
  final String facilityName;
  final dynamic issue;

  @override
  ConsumerState<CreateIssuePage> createState() => _CreateIssuePageState();
}

class _CreateIssuePageState extends ConsumerState<CreateIssuePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _locationController;
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  ProblemCategoryEntity? _selectedCategory;
  bool _categoryError = false;
  String _priority = 'medium';
  XFile? _photo;
  PartnerStaffEntity? _selectedAttendant;
  DateTime? _dueDate;
  String? _existingPhotoUrl;
  List<MasterDataItemEntity> _priorityMasterData = [];

  @override
  void initState() {
    super.initState();
    _locationController = TextEditingController(
      text: widget.issue?.location ?? widget.facilityName,
    );
    _titleController = TextEditingController(
      text: widget.issue?.title ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.issue?.description ?? '',
    );
    if (widget.issue != null) {
      _priority = widget.issue.priority ?? 'medium';
      _dueDate = widget.issue.dueDate;
    }
  }

  @override
  void dispose() {
    _locationController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _onPickImage(ImageSource source) async {
    final file = await ImagePicker().pickImage(source: source);
    if (file != null) setState(() => _photo = file);
  }

  Future<void> _onPickAttendant() async {
    final staff = await showModalBottomSheet<PartnerStaffEntity>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => IssueAttendantPickerSheet(facilityId: widget.facilityId),
    );
    if (staff != null) setState(() => _selectedAttendant = staff);
  }

  Future<void> _onPickDueDate() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (date != null) setState(() => _dueDate = date);
  }

  Future<void> _onPickCategory() async {
    final partnerId = ref.read(createIssueProvider.notifier).partnerId;
    final result = await showModalBottomSheet<({ProblemCategoryEntity value})>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => IssueCategoryPickerSheet(
        partnerId: partnerId,
        selected: _selectedCategory,
      ),
    );
    if (result != null) {
      setState(() {
        _selectedCategory = result.value;
        _categoryError = false;
      });
    }
  }

  Future<void> _onSubmit() async {
    final isEditing = widget.issue != null;
    final categoryOk = _selectedCategory != null;
    final dueDateOk = !isEditing || _dueDate != null;

    setState(() => _categoryError = !categoryOk);
    if (!_formKey.currentState!.validate() || !categoryOk || !dueDateOk) {
      if (!dueDateOk) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.locale.dueDateRequired),
            backgroundColor: context.color.error,
          ),
        );
      }
      return;
    }

    await ref.read(createIssueProvider.notifier).submit(
      request: ReportIssueRequestEntity(
        visitId: widget.visitId,
        categoryValue: _selectedCategory!.value,
        title: _titleController.text.trim(),
        priority: _priority,
        description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
        photoPath: _photo?.path,
        assignedTo: _selectedAttendant?.id,
        dueAt: _dueDate != null
            ? DateFormat('yyyy-MM-dd HH:mm:ss').format(_dueDate!)
            : null,
      ),
      categoryName: _selectedCategory!.name,
      facilityName: widget.facilityName,
      photoUrl: _photo == null ? (_existingPhotoUrl ?? widget.issue?.photoUrl) : null,
      dueDate: _dueDate,
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
          content: Text(issueState.error!.localized(context)),
          backgroundColor: context.color.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final submitState = ref.watch(createIssueProvider);
    final isEditing = widget.issue != null;

    // Fetch full issue detail, categories, and priority master data if editing
    if (isEditing) {
      final user = ref.read(getCurrentUserUseCaseProvider).call();
      final partnerId = user?.partnerId ?? 0;

      ref.listen(issueDetailProvider(widget.issue.id), (previous, next) {
        next.whenData((issueDetail) {
          if (issueDetail != null && mounted) {
            setState(() {
              _locationController.text =
                  issueDetail.facilityName ?? widget.facilityName;
              _titleController.text = issueDetail.title;
              _descriptionController.text = issueDetail.description ?? '';
              _priority = issueDetail.priority;
              _dueDate = issueDetail.dueDate;
              _existingPhotoUrl = issueDetail.photoUrl;
            });
          }
        });
      });

      // Watch categories separately and match when available
      final categoriesAsync = ref.watch(problemCategoriesProvider(partnerId));
      categoriesAsync.whenData((categories) {
        // Get current issue detail from provider
        ref.watch(issueDetailProvider(widget.issue.id)).whenData((issueDetail) {
          if (issueDetail?.problemCategory != null && categories.isNotEmpty && mounted && _selectedCategory == null) {
            // Try exact match first
            var matchedCategory = categories.where(
              (cat) => cat.value == issueDetail!.problemCategory,
            ).firstOrNull;

            // Then case-insensitive match
            matchedCategory ??= categories.where(
              (cat) => cat.value.toLowerCase() == issueDetail!.problemCategory!.toLowerCase(),
            ).firstOrNull;

            // Then partial/substring match
            matchedCategory ??= categories.where(
              (cat) => issueDetail!.problemCategory!.contains(cat.value) || cat.value.contains(issueDetail.problemCategory!),
            ).firstOrNull;

            // Fallback to first category
            matchedCategory ??= categories.first;

            if (mounted) {
              setState(() => _selectedCategory = matchedCategory);
            }
          }
        });
      });
    }

    // Fetch priority master data
    final prioritiesAsync = ref.watch(priorityMasterDataProvider);
    prioritiesAsync.whenData((priorities) {
      if (priorities.isNotEmpty && _priorityMasterData.isEmpty) {
        final sorted = List<MasterDataItemEntity>.from(priorities)
          ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() => _priorityMasterData = sorted);
          }
        });
      }
    });

    final isFormValid = _titleController.text.trim().isNotEmpty &&
        _locationController.text.trim().isNotEmpty &&
        _selectedCategory != null &&
        (!isEditing || _dueDate != null);

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: DetailAppBar(
        title: isEditing ? context.locale.editIssue : context.locale.createIssue,
      ),
      body: Column(
        children: [
          Expanded(
            child: Form(
              key: _formKey,
              child: IssueFormFieldsListView(
                titleController: _titleController,
                locationController: _locationController,
                descriptionController: _descriptionController,
                selectedCategory: _selectedCategory,
                categoryError: _categoryError,
                priority: _priority,
                photo: _photo,
                selectedAttendant: _selectedAttendant,
                dueDate: _dueDate,
                isSubmitting: submitState.isSubmitting,
                isEditing: isEditing,
                existingPhotoUrl: _existingPhotoUrl ?? widget.issue?.photoUrl,
                isFormValid: isFormValid,
                onPickCategory: _onPickCategory,
                onPriorityChanged: (p) => setState(() => _priority = p),
                onPickCamera: () => _onPickImage(ImageSource.camera),
                onPickGallery: () => _onPickImage(ImageSource.gallery),
                onRemovePhoto: () => setState(() => _photo = null),
                onPickAttendant: _onPickAttendant,
                onClearAttendant: () => setState(() => _selectedAttendant = null),
                onPickDueDate: _onPickDueDate,
                onClearDueDate: () => setState(() => _dueDate = null),
                onSubmit: () {},
                priorityMasterData: _priorityMasterData.isNotEmpty ? _priorityMasterData : null,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: context.color.onPrimary,
              border: Border(top: BorderSide(color: context.color.borderSubtle)),
            ),
            padding: EdgeInsets.fromLTRB(
              context.dimensions.spacing.s16,
              context.dimensions.spacing.s12,
              context.dimensions.spacing.s16,
              context.dimensions.spacing.s16 + MediaQuery.of(context).padding.bottom,
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => context.pop(),
                    child: Text(context.locale.cancel),
                  ),
                ),
                SizedBox(width: context.dimensions.spacing.s12),
                Expanded(
                  child: FilledButton(
                    onPressed: isFormValid && !submitState.isSubmitting ? _onSubmit : null,
                    child: submitState.isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator.adaptive(strokeWidth: 2),
                          )
                        : Text(isEditing ? context.locale.save : context.locale.create),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
