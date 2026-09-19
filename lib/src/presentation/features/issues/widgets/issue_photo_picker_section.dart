import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/text/typography.dart';

class IssuePhotoPickerSection extends StatefulWidget {
  const IssuePhotoPickerSection({
    super.key,
    required this.photo,
    required this.onCamera,
    required this.onGallery,
    required this.onRemove,
    this.existingPhotoUrl,
  });

  final XFile? photo;
  final VoidCallback onCamera;
  final VoidCallback onGallery;
  final VoidCallback onRemove;
  final String? existingPhotoUrl;

  @override
  State<IssuePhotoPickerSection> createState() => _IssuePhotoPickerSectionState();
}

class _IssuePhotoPickerSectionState extends State<IssuePhotoPickerSection> {
  bool _isEditing = false;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final hasPhoto = widget.photo != null || widget.existingPhotoUrl != null;

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
          if (hasPhoto) ...[
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(radius.r6),
                  child: widget.photo != null
                      ? Image.file(
                          File(widget.photo!.path),
                          height: 140,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                      : Image.network(
                          widget.existingPhotoUrl!,
                          height: 140,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                ),
                Positioned(
                  top: spacing.s8,
                  right: spacing.s8,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => setState(() => _isEditing = !_isEditing),
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: context.color.onPrimary,
                            shape: BoxShape.circle,
                            border: Border.all(color: context.color.primary),
                          ),
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.edit_rounded,
                            size: 14,
                            color: context.color.primary,
                          ),
                        ),
                      ),
                      Gap(spacing.s8),
                      GestureDetector(
                        onTap: () {
                          widget.onRemove();
                          setState(() => _isEditing = false);
                        },
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
                    ],
                  ),
                ),
              ],
            ),
            if (_isEditing) ...[
              Gap(spacing.s12),
              FilledButton.icon(
                onPressed: widget.onCamera,
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
            ],
          ] else ...[
            FilledButton.icon(
              onPressed: widget.onCamera,
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
          ],
        ],
      ),
    );
  }
}
