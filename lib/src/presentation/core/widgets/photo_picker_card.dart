import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/extensions/app_localization.dart';
import '../theme/theme.dart';
import '../utils/app_snackbar.dart';

/// Server limit for uploaded photos (5 MB).
const int maxPhotoBytes = 5 * 1024 * 1024;

/// Optional photo field with Camera / Gallery buttons, a preview and a remove
/// button. The parent owns the picked file via [photo] / [onChanged].
class PhotoPickerCard extends StatelessWidget {
  const PhotoPickerCard({
    super.key,
    required this.title,
    required this.photo,
    required this.onChanged,
    this.bordered = true,
  });

  final String title;
  final XFile? photo;
  final ValueChanged<XFile?> onChanged;

  /// Draws the card background and border; turn off when nested in another card.
  final bool bordered;

  Future<void> _pick(BuildContext context, ImageSource source) async {
    final XFile? file;
    try {
      file = await ImagePicker().pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1920,
      );
    } catch (_) {
      if (context.mounted) {
        AppSnackBar.showError(context, context.locale.somethingWentWrong);
      }
      return;
    }
    if (file == null) return;
    if (await file.length() > maxPhotoBytes) {
      if (context.mounted) {
        AppSnackBar.showError(context, context.locale.photoTooLarge);
      }
      return;
    }
    onChanged(file);
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final color = context.color;

    return Container(
      padding: bordered ? EdgeInsets.all(spacing.s16) : EdgeInsets.zero,
      decoration: bordered
          ? BoxDecoration(
              color: color.onPrimary,
              border: Border.all(color: color.borderSubtle),
              borderRadius: BorderRadius.circular(radius.r12),
            )
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: context.textStyle.labelLarge.copyWith(
              color: color.text.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
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
                    onTap: () => onChanged(null),
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: color.onPrimary,
                        shape: BoxShape.circle,
                        border: Border.all(color: color.error),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.close_rounded,
                        size: 14,
                        color: color.error,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Gap(spacing.s12),
          ],
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: spacing.s44,
                  child: FilledButton.icon(
                    onPressed: () => _pick(context, ImageSource.camera),
                    icon: Icon(Icons.camera_alt_outlined, size: spacing.s20),
                    label: Text(context.locale.camera),
                  ),
                ),
              ),
              Gap(spacing.s12),
              Expanded(
                child: SizedBox(
                  height: spacing.s44,
                  child: OutlinedButton.icon(
                    onPressed: () => _pick(context, ImageSource.gallery),
                    icon: Icon(Icons.image_outlined, size: spacing.s20),
                    label: Text(context.locale.gallery),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: color.primary),
                      foregroundColor: color.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
