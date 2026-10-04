import '../../core/base/base.dart';
import '../entities/menu_configuration_entity.dart';

abstract base class MenuConfigurationRepository extends Repository {
  /// Last layout stored locally. Null if never fetched or unreadable.
  MenuConfigurationEntity? getCached();

  /// Conditional fetch using the stored ETag. Success(entity) means a fresh
  /// layout (cache updated); Success(null) means unchanged, keep the cache.
  Future<Result<MenuConfigurationEntity?, Failure>> refresh();

  /// Drops the stored layout and ETag.
  Future<void> clear();
}
