import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/facility_map_entity.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/status_dot_tag.dart';
import '../../../core/widgets/text/typography.dart';
import 'tracking_launchers.dart';
import 'tracking_markers.dart';
import 'tracking_status_style.dart';

/// Details for a tapped facility pin.
class FacilityPinSheet extends StatelessWidget {
  const FacilityPinSheet({super.key, required this.facility});

  final FacilityPinEntity facility;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return _PinSheetShell(
      header: Row(
        children: [
          Icon(Icons.apartment_rounded, color: context.color.primary),
          Gap(spacing.s8),
          Expanded(
            child: LabelLargeText(facility.localizedName(context.languageCode)),
          ),
          StatusDotTag(
            label: context.locale.active,
            dotColor: context.color.primary,
          ),
        ],
      ),
      rows: [
        _InfoRow(
          icon: Icons.location_on_outlined,
          label: context.locale.addressLabel,
          value: facility.address,
        ),
        _InfoRow(
          icon: Icons.business_center_outlined,
          label: context.locale.partnerLabel,
          value: facility.partnerName,
        ),
      ],
      actions: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => openInMaps(facility.lat, facility.lng),
            icon: const Icon(Icons.map_outlined),
            label: Text(context.locale.openInMaps),
          ),
        ),
      ],
    );
  }
}

/// Details for a tapped attendant marker.
class StaffPinSheet extends StatelessWidget {
  const StaffPinSheet({super.key, required this.staff});

  final StaffPinEntity staff;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final languageCode = context.languageCode;
    final phone = staff.phoneNumber;
    final address = staff.address;

    return _PinSheetShell(
      header: Row(
        children: [
          StaffAvatar(
            name: staff.localizedName(languageCode),
            imageUrl: staff.imageUrl,
            radius: 20,
          ),
          Gap(spacing.s12),
          Expanded(child: LabelLargeText(staff.localizedName(languageCode))),
          StatusDotTag(
            label: staff.status.label(context),
            dotColor: staff.status.color(context),
          ),
        ],
      ),
      rows: [
        _InfoRow(
          icon: Icons.apartment_outlined,
          label: context.locale.facility,
          value: staff.localizedFacilityName(languageCode),
        ),
        _InfoRow(
          icon: Icons.badge_outlined,
          label: context.locale.uidLabel,
          value: staff.uid,
        ),
        _InfoRow(
          icon: Icons.phone_outlined,
          label: context.locale.phone,
          value: phone == null || phone.isEmpty
              ? '—'
              : context.numbers.phone(phone),
        ),
        _InfoRow(
          icon: Icons.location_on_outlined,
          label: context.locale.addressLabel,
          value: address == null || address.isEmpty ? '—' : address,
        ),
      ],
      actions: [
        if (phone != null && phone.isNotEmpty) ...[
          Expanded(
            child: FilledButton.icon(
              onPressed: () => callNumber(phone),
              icon: const Icon(Icons.call_outlined),
              label: Text(context.locale.callAttendant),
            ),
          ),
          Gap(spacing.s12),
        ],
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => openInMaps(staff.lat, staff.lng),
            icon: const Icon(Icons.map_outlined),
            label: Text(context.locale.openInMaps),
          ),
        ),
      ],
    );
  }
}

class _PinSheetShell extends StatelessWidget {
  const _PinSheetShell({
    required this.header,
    required this.rows,
    required this.actions,
  });

  final Widget header;
  final List<Widget> rows;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;

    return Container(
      decoration: BoxDecoration(
        color: context.color.scaffoldBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(radius.r12)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.all(spacing.s16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: context.color.borderSubtle,
                    borderRadius: BorderRadius.circular(radius.r4),
                  ),
                ),
              ),
              Gap(spacing.s16),
              header,
              Gap(spacing.s12),
              Divider(color: context.color.borderSubtle, height: 1),
              Gap(spacing.s12),
              ...rows,
              Gap(spacing.s8),
              Row(children: actions),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Padding(
      padding: EdgeInsets.only(bottom: spacing.s12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: context.color.text.secondary),
          Gap(spacing.s8),
          SizedBox(
            width: 88,
            child: Text(
              label,
              style: context.textStyle.bodySmall.copyWith(
                color: context.color.text.secondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: context.textStyle.bodyMedium.copyWith(
                color: context.color.text.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
