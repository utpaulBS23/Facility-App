import '../common/paginated_list_entity.dart';
import 'toilet_entity.dart';

/// The toilet list endpoint returns `data` + `summary` in one response —
/// this bundles both so a single provider can expose them together.
class ToiletListPageEntity {
  const ToiletListPageEntity({
    required this.list,
    required this.summary,
  });

  final PaginatedListEntity<ToiletEntity> list;
  final ToiletSummaryEntity summary;

  const ToiletListPageEntity.empty()
      : list = const PaginatedListEntity.empty(),
        summary = const ToiletSummaryEntity();
}
