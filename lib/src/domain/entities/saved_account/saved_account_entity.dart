import 'dart:typed_data';

/// An account remembered on this device for one-tap sign-in.
///
/// The password is deliberately not part of this entity: it lives in secure
/// storage and is read only at the moment of signing in.
class SavedAccountEntity {
  const SavedAccountEntity({
    required this.uid,
    required this.name,
    required this.lastLoginAt,
    this.userId,
    this.thumbnail,
    this.thumbnailUrl,
  });

  final String uid;
  final String name;
  final DateTime lastLoginAt;

  /// Backend user id, so a profile change can find its saved account (the
  /// profile does not carry the login uid).
  final int? userId;

  /// Tiny JPEG (<= 2 KB) of the profile image, null when there is none.
  final Uint8List? thumbnail;

  /// The image URL [thumbnail] was built from, so an unchanged picture is not
  /// downloaded again.
  final String? thumbnailUrl;
}
