import '../../core/base/base.dart';
import '../entities/menu_configuration_entity.dart';
import '../repositories/menu_configuration_repository.dart';

final class GetCachedMenuConfigurationUseCase {
  GetCachedMenuConfigurationUseCase(this.repository);

  final MenuConfigurationRepository repository;

  MenuConfigurationEntity? call() {
    return repository.getCached();
  }
}

final class ClearMenuConfigurationUseCase {
  ClearMenuConfigurationUseCase(this.repository);

  final MenuConfigurationRepository repository;

  Future<void> call() {
    return repository.clear();
  }
}

final class RefreshMenuConfigurationUseCase {
  RefreshMenuConfigurationUseCase(this.repository);

  final MenuConfigurationRepository repository;

  Future<Result<MenuConfigurationEntity?, Failure>> call() {
    return repository.refresh();
  }
}
