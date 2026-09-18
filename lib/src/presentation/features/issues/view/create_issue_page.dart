import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../core/extensions/failure_localization.dart';
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
  DateTime? _dueDate;

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
    final categoryOk = _selectedCategory != null;
    setState(() => _categoryError = !categoryOk);
    if (!_formKey.currentState!.validate() || !categoryOk) return;

    await ref.read(createIssueProvider.notifier).submit(
      request: ReportIssueRequestEntity(
        visitId: widget.visitId,
        categoryValue: _selectedCategory!.value,
        title: _titleController.text.trim(),
        priority: _priority,
        photoPath: _photo?.path,
        assignedTo: _selectedAttendant?.id,
        dueAt: _dueDate != null
            ? DateFormat('yyyy-MM-dd HH:mm:ss').format(_dueDate!)
            : null,
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
          content: Text(issueState.error!.localized(context)),
          backgroundColor: context.color.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final submitState = ref.watch(createIssueProvider);

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: DetailAppBar(title: context.locale.createIssue),
      body: Form(
        key: _formKey,
        child: IssueFormFieldsListView(
          titleController: _titleController,
          locationController: _locationController,
          selectedCategory: _selectedCategory,
          categoryError: _categoryError,
          priority: _priority,
          photo: _photo,
          selectedAttendant: _selectedAttendant,
          dueDate: _dueDate,
          isSubmitting: submitState.isSubmitting,
          onPickCategory: _onPickCategory,
          onPriorityChanged: (p) => setState(() => _priority = p),
          onPickCamera: () => _onPickImage(ImageSource.camera),
          onPickGallery: () => _onPickImage(ImageSource.gallery),
          onRemovePhoto: () => setState(() => _photo = null),
          onPickAttendant: _onPickAttendant,
          onClearAttendant: () => setState(() => _selectedAttendant = null),
          onPickDueDate: _onPickDueDate,
          onClearDueDate: () => setState(() => _dueDate = null),
          onSubmit: _onSubmit,
        ),
      ),
    );
  }
}
