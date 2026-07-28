import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/extensions/app_localization.dart';
import '../../../domain/entities/partner_staff_entity.dart';
import '../theme/theme.dart';

/// A tappable staff-directory row used by every "assign staff" flow.
///
/// Shows [staff]'s avatar, name, and phone/email, with an "Assigned" badge
/// when [isSelected] is true. Tapping calls [onAssign] — pass `null` to
/// disable the row (e.g. while a request is in flight, or already assigned).
class StaffTile extends StatelessWidget {
  /// Creates a [StaffTile].
  const StaffTile({
    super.key,
    required this.staff,
    required this.isSelected,
    required this.onAssign,
  });

  /// The staff member this row represents.
  final PartnerStaffEntity staff;

  /// Whether to show the "Assigned" badge and highlighted style.
  final bool isSelected;

  /// Called when the row is tapped. `null` disables the row.
  final VoidCallback? onAssign;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;

    return GestureDetector(
      onTap: onAssign,
      child: Container(
        padding: EdgeInsets.all(spacing.s16),
        decoration: BoxDecoration(
          color: isSelected
              ? context.color.brandAccent
              : context.color.onPrimary,
          border: Border.all(
            color: isSelected
                ? context.color.primary
                : context.color.borderSubtle,
          ),
          borderRadius: BorderRadius.circular(radius.r12),
        ),
        child: Row(
          children: [
            _StaffAvatar(imageUrl: staff.profileImageUrl),
            Gap(spacing.s12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    staff.name,
                    style: context.textStyle.labelLarge.copyWith(
                      color: context.color.text.primary,
                    ),
                  ),
                  Gap(spacing.s2),
                  Text(
                    staff.phoneNumber ?? staff.email,
                    style: context.textStyle.bodySmall.copyWith(
                      color: context.color.text.secondary,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: spacing.s8,
                  vertical: spacing.s4,
                ),
                decoration: BoxDecoration(
                  color: context.color.primary,
                  borderRadius: BorderRadius.circular(radius.r4),
                ),
                child: Text(
                  context.locale.assigned,
                  style: context.textStyle.labelSmall.copyWith(
                    color: context.color.onPrimary,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _StaffAvatar extends StatelessWidget {
  const _StaffAvatar({required this.imageUrl});

  final String? imageUrl;

  static const _size = 44.0;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: SizedBox.square(
        dimension: _size,
        child: Container(
          color: context.color.brandAccent,
          // WHY: loadingBuilder/errorBuilder keep the placeholder icon
          // showing until the image is fully decoded, avoiding a
          // partial/broken-image flash while it loads.
          child: imageUrl == null
              ? _placeholder(context)
              : Image.network(
                  imageUrl!,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) =>
                      progress == null ? child : _placeholder(context),
                  errorBuilder: (context, error, stackTrace) =>
                      _placeholder(context),
                ),
        ),
      ),
    );
  }

  Widget _placeholder(BuildContext context) {
    return Center(
      child: Icon(
        Icons.person_outline_rounded,
        color: context.color.text.primary,
        size: 22,
      ),
    );
  }
}
