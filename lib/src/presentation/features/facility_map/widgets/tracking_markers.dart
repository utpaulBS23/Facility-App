import 'package:flutter/material.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/facility_map_entity.dart';
import '../../../core/theme/theme.dart';
import 'tracking_status_style.dart';

/// Map pin for an active facility.
class FacilityMarker extends StatelessWidget {
  const FacilityMarker({
    super.key,
    required this.facility,
    required this.onTap,
  });

  final FacilityPinEntity facility;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = context.color.primary;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Icon(Icons.location_on_rounded, size: 44, color: color),
          Positioned(
            top: 9,
            child: Container(
              width: 18,
              height: 18,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.apartment_rounded, size: 12, color: color),
            ),
          ),
        ],
      ),
    );
  }
}

/// Map marker for an attendant: avatar (or initials) ringed by its status.
class StaffMarker extends StatelessWidget {
  const StaffMarker({super.key, required this.staff, required this.onTap});

  final StaffPinEntity staff;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final name = staff.localizedName(context.languageCode);
    final imageUrl = staff.imageUrl;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 40,
        height: 40,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: staff.status.color(context), width: 3),
          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
        ),
        child: StaffAvatar(name: name, imageUrl: imageUrl),
      ),
    );
  }
}

/// Round avatar: the photo when there is one, otherwise the name's initials.
class StaffAvatar extends StatelessWidget {
  const StaffAvatar({
    super.key,
    required this.name,
    this.imageUrl,
    this.radius,
  });

  final String name;
  final String? imageUrl;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    final url = imageUrl;

    return CircleAvatar(
      radius: radius,
      backgroundColor: context.color.borderSubtle,
      backgroundImage: url == null ? null : NetworkImage(url),
      child: url == null
          ? Text(
              _initials(name),
              style: context.textStyle.labelSmall.copyWith(
                color: context.color.text.primary,
              ),
            )
          : null,
    );
  }
}

String _initials(String name) {
  final parts = name
      .trim()
      .split(RegExp(r'\s+'))
      .where((p) => p.isNotEmpty)
      .toList();
  if (parts.isEmpty) return '?';
  final first = String.fromCharCode(parts.first.runes.first);
  if (parts.length == 1) return first;
  return '$first${String.fromCharCode(parts.last.runes.first)}';
}
