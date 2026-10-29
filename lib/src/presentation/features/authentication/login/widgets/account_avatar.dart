import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';

/// Round avatar for a saved account: the cached thumbnail when there is one,
/// otherwise colored initials. The color is derived from [uid] so an account
/// keeps the same color everywhere.
class AccountAvatar extends StatelessWidget {
  const AccountAvatar({
    super.key,
    required this.name,
    required this.uid,
    this.thumbnail,
    this.size,
  });

  final String name;
  final String uid;
  final Uint8List? thumbnail;
  /// Defaults to the standard list-row avatar size.
  final double? size;

  Color _color(BuildContext context) {
    // WHY not String.hashCode: it differs between runs, and the same account
    // must not change color on every launch.
    final sum = uid.codeUnits.fold<int>(0, (total, unit) => total + unit);
    final colors = context.color;
    final palette = [colors.primary, colors.success, colors.info, colors.warning];

    return palette[sum % palette.length];
  }

  String get _initials {
    final words = name.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty);
    final letters = words
        .take(2)
        .map((word) => String.fromCharCode(word.runes.first));

    return letters.join().toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final bytes = thumbnail;
    final size = this.size ?? context.dimensions.spacing.s40;

    return SizedBox(
      width: size,
      height: size,
      child: ClipOval(
        child: bytes != null
            ? Image.memory(
                bytes,
                fit: BoxFit.cover,
                gaplessPlayback: true,
                cacheWidth: (size * 2).round(),
                errorBuilder: (_, _, _) => _initialsAvatar(context, size),
              )
            : _initialsAvatar(context, size),
      ),
    );
  }

  Widget _initialsAvatar(BuildContext context, double size) {
    return ColoredBox(
      color: _color(context),
      child: Center(
        child: Text(
          _initials,
          style: context.textStyle.labelLarge.copyWith(
            color: context.color.onPrimary,
            fontSize: size * 0.35,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
