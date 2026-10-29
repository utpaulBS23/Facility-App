import '../../../core/base/base.dart';
import '../../repositories/profile_repository.dart';
import '../../repositories/thumbnail_repository.dart';
import 'saved_account_use_case.dart';

/// Brings a saved account's login-screen thumbnail up to date. Meant to run in
/// the background, so a failure is returned, never thrown, and leaves the
/// previous thumbnail (or the initials avatar) in place.
///
/// With no arguments it refreshes the signed-in user's own account. After a
/// profile edit the caller already holds the new picture, so it passes both.
final class RefreshSavedAccountThumbnailUseCase extends SavedAccountUseCase {
  RefreshSavedAccountThumbnailUseCase({
    required super.authRepository,
    required super.savedAccountRepository,
    required this.profileRepository,
    required this.thumbnailRepository,
  });

  final ProfileRepository profileRepository;
  final ThumbnailRepository thumbnailRepository;

  Future<Result<bool, Failure>> call({int? userId, String? imageUrl}) async {
    final user = authRepository.getCurrentUser();
    final id = userId ?? user?.id;
    if (id == null) {
      return Error(Failure.emptyResponse('find the signed-in user'));
    }

    // Not a saved account, so there is no login-screen avatar to keep fresh.
    final account = savedAccountRepository
        .getAll()
        .where((account) => account.userId == id)
        .firstOrNull;
    if (account == null) {
      return Error(Failure.emptyResponse('find a saved account'));
    }

    final url = await _resolveImageUrl(imageUrl ?? user?.profileImage);
    if (url == null) {
      return Error(Failure.emptyResponse('find a profile image'));
    }

    // WHY: the picture has not changed since the last thumbnail, so there is
    // nothing to download.
    if (account.thumbnail != null && account.thumbnailUrl == url) {
      return Success(data: false);
    }

    final thumbnail = await thumbnailRepository.fromUrl(url);

    return switch (thumbnail) {
      Success(:final data?) => savedAccountRepository.saveThumbnail(
        account.uid,
        data,
        sourceUrl: url,
      ),
      Error(:final error) => Error(error),
      _ => Error(Failure.emptyResponse('build the thumbnail')),
    };
  }

  /// WHY the profile fallback: the login payload does not always carry the
  /// picture, while the profile endpoint always does.
  Future<String?> _resolveImageUrl(String? known) async {
    if (known != null && known.isNotEmpty) return known;

    final profile = await profileRepository.getProfile();

    return switch (profile) {
      Success(:final data?) when data.profileImageUrl.isNotEmpty =>
        data.profileImageUrl,
      _ => null,
    };
  }
}
