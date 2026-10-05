import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/facility_tracking_entity.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/text/typography.dart';
import 'tracking_markers.dart';
import 'tracking_status_style.dart';

/// Attendant picker with a search box, filtered locally from the attendants
/// already loaded for the map.
///
/// Pops a `({int? staffId})` record, like the shared facility picker, so
/// "All" can be told apart from a dismissed sheet.
class TrackingAttendantSheet extends StatefulWidget {
  const TrackingAttendantSheet({
    super.key,
    required this.staff,
    required this.selectedStaffId,
  });

  final List<StaffPinEntity> staff;
  final int? selectedStaffId;

  @override
  State<TrackingAttendantSheet> createState() => _TrackingAttendantSheetState();
}

class _TrackingAttendantSheetState extends State<TrackingAttendantSheet> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;
    final languageCode = context.languageCode;
    final query = _query.trim().toLowerCase();

    final matches = [
      for (final s in widget.staff)
        if (query.isEmpty ||
            s.name.toLowerCase().contains(query) ||
            s.nameBn.toLowerCase().contains(query) ||
            s.uid.toLowerCase().contains(query))
          s,
    ];

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.8,
      ),
      decoration: BoxDecoration(
        color: context.color.scaffoldBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(radius.r12)),
      ),
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Material(
        type: MaterialType.transparency,
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Gap(spacing.s12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: context.color.borderSubtle,
                  borderRadius: BorderRadius.circular(radius.r4),
                ),
              ),
              Gap(spacing.s16),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: spacing.s16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: LabelLargeText(context.locale.attendant),
                ),
              ),
              Gap(spacing.s8),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: spacing.s16),
                child: TextField(
                  onChanged: (value) => setState(() => _query = value),
                  decoration: InputDecoration(
                    hintText: context.locale.searchAttendantHint,
                    prefixIcon: const Icon(Icons.search_rounded),
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(radius.r10),
                    ),
                  ),
                ),
              ),
              Gap(spacing.s8),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.fromLTRB(
                    spacing.s16,
                    0,
                    spacing.s16,
                    spacing.s16,
                  ),
                  children: [
                    if (query.isEmpty)
                      _row(
                        context,
                        staffId: null,
                        title: Text(context.locale.all),
                      ),
                    for (final s in matches) ...[
                      Gap(spacing.s8),
                      _row(
                        context,
                        staffId: s.id,
                        leading: StaffAvatar(
                          name: s.localizedName(languageCode),
                          imageUrl: s.imageUrl,
                          radius: 18,
                        ),
                        title: Text(s.localizedName(languageCode)),
                        subtitle: Text(
                          '${s.uid} · ${s.status.label(context)}',
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(
    BuildContext context, {
    required int? staffId,
    required Widget title,
    Widget? subtitle,
    Widget? leading,
  }) {
    final isSelected = staffId == widget.selectedStaffId;

    return ListTile(
      onTap: () => Navigator.of(context).pop((staffId: staffId)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.dimensions.radius.r10),
        side: BorderSide(
          color: isSelected
              ? context.color.primary
              : context.color.borderSubtle,
        ),
      ),
      leading: leading,
      title: title,
      subtitle: subtitle,
      trailing: isSelected
          ? Icon(Icons.check_circle_rounded, color: context.color.primary)
          : null,
    );
  }
}
