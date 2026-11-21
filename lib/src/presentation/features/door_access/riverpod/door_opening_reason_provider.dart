import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/logger/log.dart';

class DoorOpeningReason {
  DoorOpeningReason({
    required this.id,
    required this.name,
    required this.key,
    required this.label,
    this.labelBn,
    this.color,
    this.sublabel,
    this.sublabelBn,
  });

  final int id;
  final String name;
  final String key;
  final String label;
  final String? labelBn;
  final String? color;
  final String? sublabel;
  final String? sublabelBn;

  String getLocalizedLabel(String languageCode) {
    return languageCode == 'bn' && labelBn != null ? labelBn! : label;
  }

  String? getLocalizedSublabel(String languageCode) {
    return languageCode == 'bn' && sublabelBn != null ? sublabelBn : sublabel;
  }
}

final doorOpeningReasonProvider =
    FutureProvider.family<List<DoorOpeningReason>, int>(
  (ref, partnerId) async {
    Log.info('🎯 doorOpeningReasonProvider CALLED for partner: $partnerId');

    try {
      final restClient = ref.read(restClientServiceProvider);
      Log.info('📡 Fetching door opening reasons');
      final response = await restClient.getMasterDataItems(
        partnerId: partnerId,
        category: 'doorOpeningReason',
        perPage: 100,
        includeInactive: true,
      );

      final data = response.data as Map<String, dynamic>? ?? {};
      final itemsList = data['data'] as List? ?? [];
      Log.info('✅ Loaded ${itemsList.length} door opening reasons');

      return itemsList.map((item) {
        final itemMap = item as Map<String, dynamic>;
        final key = itemMap['key'] as String? ?? '';
        final label = itemMap['label'] as String? ?? itemMap['name'] as String? ?? '';
        final finalKey = key.isNotEmpty ? key : label.toLowerCase().replaceAll(' ', '_');

        return DoorOpeningReason(
          id: itemMap['id'] as int? ?? 0,
          name: itemMap['name'] as String? ?? '',
          key: finalKey,
          label: label,
          labelBn: itemMap['label_bn'] as String?,
          color: itemMap['color'] as String?,
          sublabel: itemMap['sublabel'] as String?,
          sublabelBn: itemMap['sublabel_bn'] as String?,
        );
      }).toList();
    } catch (e, st) {
      Log.error('❌ Error fetching door opening reasons: $e');
      Log.error(st.toString());
      return [];
    }
  },
);
