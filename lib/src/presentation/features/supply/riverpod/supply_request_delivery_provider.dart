import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/supply/delivery_entity.dart';

part 'supply_request_delivery_provider.g.dart';

@riverpod
Future<DeliveryEntity?> supplyRequestDelivery(
  Ref ref,
  String requestCode,
) async {
  final result = await ref
      .read(getDeliveryForSupplyRequestUseCaseProvider)
      .call(requestCode: requestCode);

  return result.when(
    success: (data) => data,
    error: (error) => throw Exception(error.message),
  );
}
