import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Stroke icon paths of the dashboard design (24x24 grid).
abstract final class DashboardIconPaths {
  static const bell =
      'M18 8a6 6 0 10-12 0c0 7-3 9-3 9h18s-3-2-3-9M13.7 21a2 2 0 01-3.4 0';
  static const checkIn =
      'M15 3h4a2 2 0 012 2v14a2 2 0 01-2 2h-4M10 17l5-5-5-5M15 12H3';
  static const checkOut =
      'M9 21H5a2 2 0 01-2-2V5a2 2 0 012-2h4M16 17l5-5-5-5M21 12H9';
  static const pin =
      'M20 10c0 6-8 12-8 12S4 16 4 10a8 8 0 0116 0zM12 7a3 3 0 100 6 3 3 0 000-6z';
  static const chevronRight = 'M9 6l6 6-6 6';
  static const chevronDown = 'M6 9l6 6 6-6';
  static const arrowRight = 'M5 12h14M13 6l6 6-6 6';
  static const lock = 'M5 11h14v10H5zM8 11V7a4 4 0 018 0v4';
  static const warning =
      'M10.3 3.9L1.8 18a2 2 0 001.7 3h17a2 2 0 001.7-3L13.7 3.9a2 2 0 00-3.4 0zM12 9v4M12 17h.01';
  static const odour =
      'M9.6 4.6A2 2 0 1111 8H2M12.6 19.4A2 2 0 1014 16H2M17.7 7.7A2.5 2.5 0 1119.5 12H2';
  static const camera =
      'M23 7l-7 5 7 5V7zM3 5h11a2 2 0 012 2v10a2 2 0 01-2 2H3a2 2 0 01-2-2V7a2 2 0 012-2z';
  static const device = 'M4 4h16v12H4zM8 20h8M12 16v4';
  static const staff =
      'M17 21v-2a4 4 0 00-4-4H5a4 4 0 00-4 4v2M9 3a4 4 0 100 8 4 4 0 000-8zM23 21v-2a4 4 0 00-3-3.9M16 3.1a4 4 0 010 7.8';
  static const attendance = 'M12 2a10 10 0 100 20 10 10 0 000-20zM12 6v6l4 2';
  static const variance = 'M2 6h20v12H2zM12 9a3 3 0 100 6 3 3 0 000-6z';
  static const approval = 'M22 11.1V12a10 10 0 11-5.9-9.1M22 4L12 14l-3-3';
  static const digest =
      'M4 4h16a2 2 0 012 2v12a2 2 0 01-2 2H4a2 2 0 01-2-2V6a2 2 0 012-2zM22 6l-10 7L2 6';
  static const stock = 'M21 8l-9-5-9 5v8l9 5 9-5zM3 8l9 5 9-5M12 13v8';

  /// The paths of the "assign staff" glyph (a person with a plus badge).
  static const assignStaff = 'M9.5 15.5a5 5 0 019 0M6 15.8v4.4M3.8 18h4.4';

  /// The circles of [assignStaff]; `BG` is replaced by the surface colour.
  static const assignStaffShapes =
      '<circle cx="14" cy="10" r="8"/><circle cx="14" cy="8.5" r="2.5"/>'
      '<circle cx="6" cy="18" r="4.5" fill="BG"/>';

  /// Notification and preference kinds, as sent by the backend.
  static const Map<String, String> byKind = {
    'odour': odour,
    'camera': camera,
    'device': device,
    'staffing': staff,
    'attendance': attendance,
    'issue': warning,
    'variance': variance,
    'approval': approval,
    'digest': digest,
    'stock': stock,
  };
}

String _hex(Color c) =>
    '#${(c.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0')}';

/// A stroked 24x24 icon drawn from an svg path string, in [color].
class DashboardIcon extends StatelessWidget {
  const DashboardIcon(
    this.path, {
    super.key,
    required this.color,
    this.size = 20,
    this.strokeWidth = 2,
  });

  final String path;
  final Color color;
  final double size;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.string(
      '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" '
      'fill="none" stroke="${_hex(color)}" stroke-width="$strokeWidth" '
      'stroke-linecap="round" stroke-linejoin="round">'
      '<path d="$path"/></svg>',
      width: size,
      height: size,
    );
  }
}

/// The "assign staff" icon (a person with a plus), in [color].
class AssignStaffIcon extends StatelessWidget {
  const AssignStaffIcon({
    super.key,
    required this.color,
    required this.badge,
    this.size = 20,
  });

  final Color color;

  /// Fill of the plus badge: the colour of the surface behind the icon.
  final Color badge;
  final double size;

  @override
  Widget build(BuildContext context) {
    final shapes = DashboardIconPaths.assignStaffShapes.replaceAll(
      'BG',
      _hex(badge),
    );
    return SvgPicture.string(
      '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" '
      'fill="none" stroke="${_hex(color)}" stroke-width="2" '
      'stroke-linecap="round" stroke-linejoin="round">'
      '$shapes<path d="${DashboardIconPaths.assignStaff}"/></svg>',
      width: size,
      height: size,
    );
  }
}
