import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/text/typography.dart';

class IssuePhotoPickerSection extends StatelessWidget {
  const IssuePhotoPickerSection({
    super.key,
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
