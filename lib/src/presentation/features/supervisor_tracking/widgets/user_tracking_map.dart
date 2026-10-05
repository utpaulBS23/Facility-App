import 'package:flutter/material.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/user_tracking_entity.dart';
import '../../../core/map/app_map.dart';
import '../../../core/map/map_control_button.dart';
import '../../../core/theme/theme.dart';
import 'user_marker.dart';

/// Map with a marker per user. The camera fits every visible marker whenever
/// the set of markers changes, and moves to the selected user when one is
/// picked.
class UserTrackingMap extends StatefulWidget {
  const UserTrackingMap({
    super.key,
    required this.positions,
    required this.selectedUserId,
    required this.onUserTap,
  });

  final List<UserPositionEntity> positions;
  final int? selectedUserId;
  final ValueChanged<UserPositionEntity> onUserTap;

  @override
  State<UserTrackingMap> createState() => _UserTrackingMapState();
}

class _UserTrackingMapState extends State<UserTrackingMap> {
  final _controller = AppMapController();

  @override
  void initState() {
    super.initState();
    widget.selectedUserId == null ? _fit() : _focusSelected();
  }

  @override
  void didUpdateWidget(UserTrackingMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedUserId != null &&
        widget.selectedUserId != oldWidget.selectedUserId) {
      _focusSelected();
    } else if (!_samePins(oldWidget)) {
      _fit();
    }
  }

  bool _samePins(UserTrackingMap other) {
    final oldIds = {for (final p in other.positions) p.userId};
    final newIds = {for (final p in widget.positions) p.userId};
    return oldIds.length == newIds.length && oldIds.containsAll(newIds);
  }

  void _focusSelected() {
    final selected = widget.positions
        .where((p) => p.userId == widget.selectedUserId)
        .firstOrNull;
    if (selected == null) {
      _fit();
      return;
    }
    _controller.moveTo((lat: selected.lat, lng: selected.lng));
  }

  void _fit() => _controller.fit([
    for (final p in widget.positions) (lat: p.lat, lng: p.lng),
  ]);

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Stack(
      children: [
        AppMap(
          controller: _controller,
          markers: [
            for (final position in widget.positions)
              MapMarker(
                id: 'u${position.userId}',
                lat: position.lat,
                lng: position.lng,
                size: const Size(36, 36),
                child: UserMarker(
                  position: position,
                  selected: position.userId == widget.selectedUserId,
                  onTap: () => widget.onUserTap(position),
                ),
              ),
          ],
        ),
        Positioned(left: spacing.s12, top: spacing.s12, child: const _Legend()),
        Positioned(
          right: spacing.s12,
          bottom: spacing.s12,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              MapControlButton(
                icon: Icons.add_rounded,
                onTap: () => _controller.zoomBy(1),
              ),
              SizedBox(height: spacing.s8),
              MapControlButton(
                icon: Icons.remove_rounded,
                onTap: () => _controller.zoomBy(-1),
              ),
              SizedBox(height: spacing.s8),
              MapControlButton(icon: Icons.my_location_rounded, onTap: _fit),
            ],
          ),
        ),
      ],
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend();

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Container(
      padding: EdgeInsets.all(spacing.s8),
      decoration: BoxDecoration(
        color: context.color.onPrimary,
        borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
        border: Border.all(color: context.color.borderSubtle),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _LegendRow(
            color: context.color.success,
            label: context.locale.statusOnline,
          ),
          SizedBox(height: spacing.s4),
          _LegendRow(
            color: context.color.text.muted,
            label: context.locale.offline,
          ),
        ],
      ),
    );
  }
}

class _LegendRow extends StatelessWidget {
  const _LegendRow({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: context.dimensions.spacing.s8),
        Text(label, style: context.textStyle.bodySmall),
      ],
    );
  }
}
