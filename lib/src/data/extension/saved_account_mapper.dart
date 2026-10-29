import 'dart:convert';
import 'dart:typed_data';

import '../../domain/entities/saved_account/saved_account_entity.dart';
import '../models/saved_account/saved_account_model.dart';

extension SavedAccountModelToEntity on SavedAccountModel {
  SavedAccountEntity toEntity() {
    Uint8List? bytes;
    final encoded = thumbnail;
    if (encoded != null && encoded.isNotEmpty) {
      try {
        bytes = base64Decode(encoded);
      } on FormatException {
        // WHY swallowed: a corrupt thumbnail falls back to the initials avatar.
        bytes = null;
      }
    }

    return SavedAccountEntity(
      uid: uid,
      name: name,
      lastLoginAt: DateTime.fromMillisecondsSinceEpoch(lastLoginAt),
      userId: userId,
      thumbnail: bytes,
      thumbnailUrl: thumbnailUrl,
    );
  }
}

extension SavedAccountEntityToModel on SavedAccountEntity {
  SavedAccountModel toModel() {
    final bytes = thumbnail;

    return SavedAccountModel(
      uid: uid,
      name: name,
      lastLoginAt: lastLoginAt.millisecondsSinceEpoch,
      userId: userId,
      thumbnail: bytes == null ? null : base64Encode(bytes),
      thumbnailUrl: thumbnailUrl,
    );
  }
}
