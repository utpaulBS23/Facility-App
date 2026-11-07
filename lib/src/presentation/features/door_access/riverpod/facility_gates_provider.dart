import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/logger/log.dart';

class GateData {
  GateData({
    required this.id,
    required this.deviceId,
    required this.gender,
    required this.serviceTitleEn,
    required this.serviceTitleBn,
    required this.price,
  });

  final int id;
  final String deviceId;
  final String gender;
  final String serviceTitleEn;
  final String serviceTitleBn;
  final double price;

  String getLocalizedTitle(String languageCode) {
    return languageCode == 'bn' ? serviceTitleBn : serviceTitleEn;
  }
}

final facilityGatesProvider =
    FutureProvider.family<List<GateData>, String>(
  (ref, facilityId) async {
    Log.info('🎯 facilityGatesProvider called for facility: $facilityId');
    final session = ref.watch(authenticationRepositoryProvider).currentSession;
    if (session == null) {
      Log.warning('⚠️ No session found');
      return [];
    }

    final partnerId = session.activePartnerId;
    if (partnerId == null) {
      Log.warning('⚠️ No partnerId found');
      return [];
    }

    try {
      final restClient = ref.read(restClientServiceProvider);
      Log.info('📡 Fetching gates for facility $facilityId (partner: $partnerId)');
      final response = await restClient.getFacilityNodeGates(
        partnerId: partnerId,
        facilityId: facilityId,
        perPage: 100,
      );

      final data = response.data as Map<String, dynamic>? ?? {};
      final gatesList = data['data'] as List? ?? [];
      Log.info('✅ Loaded ${gatesList.length} gates');

      return gatesList.map((gate) {
        final gateMap = gate as Map<String, dynamic>;
        final service = gateMap['service'] as Map<String, dynamic>? ?? {};

        return GateData(
          id: gateMap['id'] as int? ?? 0,
          deviceId: gateMap['door'] as String? ?? '',
          gender: gateMap['gender'] as String? ?? 'male',
          serviceTitleEn: service['title_en'] as String? ?? '',
          serviceTitleBn: service['title_bn'] as String? ?? '',
          price: (service['price'] as num?)?.toDouble() ?? 0.0,
        );
      }).toList();
    } catch (e, st) {
      Log.error('Error fetching facility gates: $e');
      Log.error(st.toString());
      return [];
    }
  },
);