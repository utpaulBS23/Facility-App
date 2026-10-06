import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/application_state/session_provider/session_provider.dart';
import 'toilets_provider.dart';

/// The name of toilet [facilityId], or null while it is not known.
///
/// WHY two sources: the user's accessible facilities come with the session, so
/// they answer at once and cost no request. A toilet outside that list is
/// looked up in the toilet list, which is only fetched when needed.
String? toiletNameOf(WidgetRef ref, int facilityId, String languageCode) {
  final fromSession = ref.watch(
    userSessionProvider.select(
      (s) => s?.accessibleFacilities
          .where((f) => f.id == facilityId)
          .firstOrNull
          ?.localizedName(languageCode),
    ),
  );
  if (fromSession != null) return fromSession;

  final page = ref.watch(toiletsProvider).valueOrNull;

  return page?.list.items.where((t) => t.id == facilityId).firstOrNull?.name;
}
