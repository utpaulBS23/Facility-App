import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart' show HttpResponse;

import '../../core/base/base.dart';
import '../../domain/entities/menu_configuration_entity.dart';
import '../../domain/repositories/menu_configuration_repository.dart';
import '../extension/menu_configuration_mapper.dart';
import '../models/menu_configuration_model.dart';
import '../services/cache/cache_service.dart';
import '../services/network/rest_client.dart';

final class MenuConfigurationRepositoryImpl extends MenuConfigurationRepository {
  MenuConfigurationRepositoryImpl(this.remote, this.local);

  final RestClient remote;
  final CacheService local;

  @override
  MenuConfigurationEntity? getCached() {
    final raw = local.get<String>(CacheKey.menuConfigurationData);
    if (raw == null) return null;

    // WHY swallowed: a corrupt cache entry must fall back to the hardcoded
    // layout, never crash the shell.
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      return MenuConfigurationDataModel.fromJson(json).toEntity();
    } on Exception {
      return null;
    }
  }

  @override
  Future<void> clear() {
    return local.remove([
      CacheKey.menuConfigurationEtag,
      CacheKey.menuConfigurationData,
    ]);
  }

  @override
  Future<Result<MenuConfigurationEntity?, Failure>> refresh() {
    return asyncGuard(() async {
      final etag = local.get<String>(CacheKey.menuConfigurationEtag);

      final HttpResponse response;
      try {
        response = await remote.getMenuConfiguration(ifNoneMatch: etag);
      } on DioException catch (e) {
        // 304 has no body and Dio's default validateStatus throws on it.
        if (e.response?.statusCode == 304) return null;
        rethrow;
      }

      final responseModel = MenuConfigurationResponseModel.fromJson(
        response.data,
      );
      final data = responseModel.data;
      if (data == null) return null;

      // WHY raw header: the quotes must be sent back exactly as received.
      final newEtag = response.response.headers.value('etag');
      if (newEtag != null) {
        await local.save(CacheKey.menuConfigurationEtag, newEtag);
      }
      await local.save(
        CacheKey.menuConfigurationData,
        jsonEncode((response.data as Map<String, dynamic>)['data']),
      );

      return data.toEntity();
    });
  }
}
