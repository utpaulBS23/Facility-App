import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../core/theme/theme.dart';

void showTaskProofBottomSheet(
  BuildContext context, {
  required Future<void> Function(String photoPath, String alt) onSubmit,
}) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _ProofRequiredBottomSheet(onSubmit: onSubmit),
  );
}

class _ProofRequiredBottomSheet extends StatefulWidget {
  const _ProofRequiredBottomSheet({required this.onSubmit});

  final Future<void> Function(String photoPath, String alt) onSubmit;

  @override
  State<_ProofRequiredBottomSheet> createState() =>
      _ProofRequiredBottomSheetState();
}

class _ProofRequiredBottomSheetState extends State<_ProofRequiredBottomSheet> {
  final _altController = TextEditingController();
  final _picker = ImagePicker();
  XFile? _image;
  bool _isSubmitting = false;
  bool _showAltError = false;

  @override
  void dispose() {
    _altController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final photo = await _picker.pickImage(source: source, imageQuality: 85);
    if (photo == null) return;
    setState(() => _image = photo);
  }

  void _deleteImage() => setState(() => _image = null);

  Future<void> _submit() async {
    final alt = _altController.text.trim();
    if (alt.isEmpty) {
      setState(() => _showAltError = true);
      return;
    }
    if (_image == null) return;

    setState(() {
      _isSubmitting = true;
      _showAltError = false;
    });

    try {
      await widget.onSubmit(_image!.path, alt);
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (_) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.locale.uploadTaskMediaFailed)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Container(
      decoration: BoxDecoration(
        color: context.color.onPrimary,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
        spacing.s24,
        spacing.s12,
        spacing.s24,
        spacing.s24 + MediaQuery.of(context).padding.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: context.color.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Gap(spacing.s24),
          if (_image == null)
            ..._pickerView(context, spacing)
          else
            ..._previewView(context, spacing),
        ],
      ),
    );
  }

  List<Widget> _pickerView(BuildContext context, dynamic spacing) => [
    Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: context.color.brandSubtle,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.camera_alt_outlined,
        size: 32,
        color: context.color.primary,
      ),
    ),
    Gap(spacing.s16),
    Text(
      context.locale.proofRequired,
      style: context.textStyle.titleMedium.copyWith(
        color: context.color.text.primary,
      ),
      textAlign: TextAlign.center,
    ),
    Gap(spacing.s8),
    Text(
      context.locale.proofRequiredSubtitle,
      style: context.textStyle.bodyMedium.copyWith(
        color: context.color.text.secondary,
      ),
      textAlign: TextAlign.center,
    ),
    Gap(spacing.s24),
    FilledButton(
      onPressed: () => _pickImage(ImageSource.camera),
      child: Text(context.locale.takePhoto),
    ),
    Gap(spacing.s12),
    OutlinedButton(
      onPressed: () => _pickImage(ImageSource.gallery),
      style: OutlinedButton.styleFrom(
        foregroundColor: context.color.primary,
        side: BorderSide(color: context.color.primary),
      ),
      child: Text(context.locale.gallery),
    ),
  ];

  List<Widget> _previewView(BuildContext context, dynamic spacing) => [
    Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
          child: Image.file(
            File(_image!.path),
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: spacing.s8,
          right: spacing.s8,
          child: GestureDetector(
            onTap: _isSubmitting ? null : _deleteImage,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: context.color.overlay,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.close,
                color: context.color.onPrimary,
                size: 18,
              ),
            ),
          ),
        ),
      ],
    ),
    Gap(spacing.s12),
    OutlinedButton.icon(
      onPressed: _isSubmitting ? null : () => _pickImage(ImageSource.camera),
      icon: const Icon(Icons.refresh, size: 18),
      label: Text(context.locale.changePhoto),
      style: OutlinedButton.styleFrom(
        foregroundColor: context.color.primary,
        side: BorderSide(color: context.color.primary),
      ),
    ),
    Gap(spacing.s16),
    TextField(
      controller: _altController,
      enabled: !_isSubmitting,
      decoration: InputDecoration(
        labelText: context.locale.proofAltLabel,
        hintText: context.locale.proofAltHint,
        errorText: _showAltError ? context.locale.isRequired : null,
      ),
    ),
    Gap(spacing.s24),
    FilledButton(
      onPressed: _isSubmitting ? null : _submit,
      child: _isSubmitting
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: context.color.onPrimary,
              ),
            )
          : Text(context.locale.submitProof),
    ),
  ];
}
