import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/logger/log.dart';
import '../../../core/theme/theme.dart';
import '../../../../data/models/door_status_model.dart';

final doorStatesProvider =
    FutureProvider.family<List<DoorStatusModel>, (String, String)>(
  (ref, params) async {
    final (facilityId, authCode) = params;
    Log.info('📊 doorStatesProvider CALLED for facility: $facilityId');

    try {
      final gatewayService = ref.read(gatewayServiceProvider);
      Log.info('🚪 Fetching door statuses from Pi');
      final doorsList = await gatewayService.getDoorStatuses(
        authCode: authCode,
      );

      final statuses = doorsList
          .map((door) => DoorStatusModel.fromJson(door))
          .toList();

      Log.info('✅ Loaded ${statuses.length} door statuses');
      return statuses;
    } catch (e, st) {
      Log.error('❌ Error fetching door statuses: $e');
      Log.error(st.toString());
      return [];
    }
  },
);
