import 'package:riverpod_annotation/riverpod_annotation.dart';


import '../../../../domain/entities/visit_entity.dart';

part 'my_visits_provider.g.dart';

@riverpod
class MyVisits extends _$MyVisits {
  @override
  AsyncValue<VisitListEntity> build() {
    final now = DateTime.now();
    final todayStr =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    return AsyncValue.data(
      VisitListEntity(
        stats: const VisitStatsSummaryEntity(
          todayCount: 3,
          weekCount: 7,
          completedCount: 2,
        ),
        visits: [
          VisitSummaryEntity(
            id: 1,
            facilityName: 'Dhaka Central Tower',
            facilityAddress: '45 Motijheel C/A, Dhaka 1000',
            status: VisitStatus.scheduled,
            type: VisitType.routineInspection,
            date: todayStr,
            startTime: '09:00',
            endTime: '11:00',
          ),
          VisitSummaryEntity(
            id: 2,
            facilityName: 'Gulshan Trade Center',
            facilityAddress: '12 Gulshan Ave, Dhaka 1212',
            status: VisitStatus.completed,
            type: VisitType.routineInspection,
            date: todayStr,
            startTime: '11:30',
            endTime: '13:00',
          ),
          VisitSummaryEntity(
            id: 3,
            facilityName: 'Banani Corporate Hub',
            facilityAddress: '8 Kemal Ataturk Ave, Dhaka 1213',
            status: VisitStatus.pending,
            type: VisitType.followUp,
            date: todayStr,
            startTime: '14:00',
            endTime: '16:00',
          ),
        ],
      ),
    );
  }

  Future<void> fetch({required String date}) async {
    // TODO: replace with real API call
    final now = DateTime.now();
    final todayStr =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    state = AsyncValue.data(
      VisitListEntity(
        stats: const VisitStatsSummaryEntity(
          todayCount: 3,
          weekCount: 7,
          completedCount: 2,
        ),
        visits: [
          VisitSummaryEntity(
            id: 1,
            facilityName: 'Dhaka Central Tower',
            facilityAddress: '45 Motijheel C/A, Dhaka 1000',
            status: VisitStatus.scheduled,
            type: VisitType.routineInspection,
            date: todayStr,
            startTime: '09:00',
            endTime: '11:00',
          ),
          VisitSummaryEntity(
            id: 2,
            facilityName: 'Gulshan Trade Center',
            facilityAddress: '12 Gulshan Ave, Dhaka 1212',
            status: VisitStatus.completed,
            type: VisitType.routineInspection,
            date: todayStr,
            startTime: '11:30',
            endTime: '13:00',
          ),
          VisitSummaryEntity(
            id: 3,
            facilityName: 'Banani Corporate Hub',
            facilityAddress: '8 Kemal Ataturk Ave, Dhaka 1213',
            status: VisitStatus.pending,
            type: VisitType.followUp,
            date: todayStr,
            startTime: '14:00',
            endTime: '16:00',
          ),
        ],
      ),
    );
  }
}
