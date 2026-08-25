import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Invalidates all repository providers in the dependency injection container.
///
/// This forces fresh repository instances on next access, clearing any
/// in-memory cache upon logout or context change.
void resetRepositories(Ref ref) {
  for (final element in ref.container.getAllProviderElements()) {
    if (element.provider.name?.contains('Repository') ?? false) {
      ref.invalidate(element.provider);
    }
  }
}
