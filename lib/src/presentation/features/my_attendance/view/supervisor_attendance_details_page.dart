import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../core/extensions/failure_localization.dart';
import '../../../../domain/entities/supervisor_attendance_detail_entity.dart';
import '../../../core/theme/theme.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/detail_app_bar.dart';
import '../riverpod/supervisor_attendance_detail_provider.dart';

/// One supervisor's visits for one day: times, GPS check, checklist score.
class SupervisorAttendanceDetailsPage extends ConsumerWidget {
  const SupervisorAttendanceDetailsPage({
    super.key,
    required this.userId,
    required this.date,
  });

  final int userId;

  /// `yyyy-MM-dd`, the row's own date.
  final String date;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(
      supervisorAttendanceDetailProvider(userId: userId, date: date),
    );
    final parsedDate = DateTime.tryParse(date);

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: DetailAppBar(
        title: context.locale.attendanceDetails,
        subtitle: parsedDate == null ? null : DateFormatter.shiftDate(parsedDate),
      ),
      body: detailAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text(err.localizedMessage(context))),
        data: (detail) => RefreshIndicator(
          onRefresh: () async => ref.invalidate(
            supervisorAttendanceDetailProvider(userId: userId, date: date),
          ),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(context.dimensions.spacing.s16),
            children: [
              _SummaryCard(detail: detail),
              Gap(context.dimensions.spacing.s16),
              Text(
                context.locale.visits,
                style: context.textStyle.titleMedium.copyWith(
                  color: context.color.text.primary,
                ),
              ),
              Gap(context.dimensions.spacing.s8),
              for (final visit in detail.visits) ...[
                _VisitCard(visit: visit),
                Gap(context.dimensions.spacing.s12),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

String _time(DateTime? value) =>
    value == null ? '—' : DateFormatter.timeOnly(value);

BoxDecoration _cardDecoration(BuildContext context) => BoxDecoration(
  color: context.color.onPrimary,
  border: Border.all(color: context.color.borderSubtle),
  borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
);

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.detail});

  final SupervisorAttendanceDetailEntity detail;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final neutral = context.color.borderSubtle.withValues(alpha: 0.2);

    return Container(
      padding: EdgeInsets.all(spacing.s12),
      decoration: _cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  detail.localizedSupervisorName(context.languageCode),
                  style: context.textStyle.titleMedium.copyWith(
                    color: context.color.text.primary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (detail.stillOnRound) const _StatusTag(),
            ],
          ),
          Gap(spacing.s12),
          Row(
            children: [
              _InfoTile(
                label: context.locale.checkIn,
                value: _time(detail.checkInAt),
                background: neutral,
              ),
              Gap(spacing.s6),
              _InfoTile(
                label: context.locale.checkOut,
                value: _time(detail.checkOutAt),
                background: neutral,
              ),
              Gap(spacing.s6),
              _InfoTile(
                label: context.locale.duration,
                value: detail.minutes == null
                    ? '—'
                    : context.locale.minutesValue(detail.minutes.toString()),
                background: neutral,
              ),
            ],
          ),
          Gap(spacing.s6),
          Row(
            children: [
              _InfoTile(
                label: context.locale.visits,
                value: detail.visitCount.toString(),
                background: neutral,
              ),
              Gap(spacing.s6),
              _InfoTile(
                label: context.locale.facilities,
                value: detail.facilitiesCount.toString(),
                background: neutral,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.label,
    required this.value,
    required this.background,
  });

  final String label;
  final String value;
  final Color background;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Expanded(
      child: Container(
        padding: EdgeInsets.all(spacing.s10),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(context.dimensions.radius.r10),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: context.textStyle.titleMedium.copyWith(
                color: context.color.text.primary,
              ),
              textAlign: TextAlign.center,
            ),
            Gap(spacing.s4),
            Text(
              label,
              style: context.textStyle.bodySmall.copyWith(
                color: context.color.text.secondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusTag extends StatelessWidget {
  const _StatusTag();

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.s8,
        vertical: spacing.s2,
      ),
      decoration: BoxDecoration(
        color: context.color.successAlt,
        borderRadius: BorderRadius.circular(context.dimensions.radius.r6),
      ),
      child: Text(
        context.locale.stillOnRound,
        style: context.textStyle.bodySmall.copyWith(
          color: context.color.success,
        ),
      ),
    );
  }
}

class _VisitCard extends StatelessWidget {
  const _VisitCard({required this.visit});

  final SupervisorVisitEntity visit;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final secondary = context.textStyle.bodySmall.copyWith(
      color: context.color.text.secondary,
    );
    final place = visit.localizedPlace(context.languageCode);
    final title = visit.localizedTitle(context.languageCode);
    final address = visit.address?.trim();
    final notes = visit.supervisorNotes?.trim();

    return Container(
      padding: EdgeInsets.all(spacing.s12),
      decoration: _cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title.isEmpty ? place : title,
                  style: context.textStyle.labelLarge.copyWith(
                    color: context.color.text.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (visit.isInProgress) const _StatusTag(),
            ],
          ),
          Gap(spacing.s4),
          Row(
            children: [
              Icon(
                visit.isExternal
                    ? Icons.location_on_rounded
                    : Icons.apartment_outlined,
                size: 14,
                color: context.color.text.secondary,
              ),
              Gap(spacing.s4),
              Expanded(child: Text(place, style: secondary)),
            ],
          ),
          if (address != null && address.isNotEmpty) ...[
            Gap(spacing.s2),
            Text(address, style: secondary),
          ],
          if (visit.scheduledStart != null || visit.scheduledEnd != null) ...[
            Gap(spacing.s8),
            Text(
              '${context.locale.scheduled}: ${_time(visit.scheduledStart)} – ${_time(visit.scheduledEnd)}',
              style: secondary,
            ),
          ],
          Gap(spacing.s8),
          Row(
            children: [
              _TimeChip(icon: Icons.login_rounded, time: _time(visit.checkInAt)),
              Gap(spacing.s12),
              _TimeChip(
                icon: Icons.logout_rounded,
                time: _time(visit.checkOutAt),
              ),
              if (visit.minutes != null) ...[
                Gap(spacing.s12),
                Text(
                  context.locale.minutesValue(visit.minutes.toString()),
                  style: secondary,
                ),
              ],
            ],
          ),
          if (visit.locationVerified != null) ...[
            Gap(spacing.s8),
            _LocationRow(visit: visit),
          ],
          if (visit.scorePercentage != null) ...[
            Gap(spacing.s10),
            _ScoreRow(visit: visit),
          ],
          if (notes != null && notes.isNotEmpty) ...[
            Gap(spacing.s10),
            Text(
              context.locale.notes,
              style: secondary.copyWith(fontWeight: FontWeight.bold),
            ),
            Gap(spacing.s2),
            Text(
              notes,
              style: context.textStyle.bodySmall.copyWith(
                color: context.color.text.primary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _TimeChip extends StatelessWidget {
  const _TimeChip({required this.icon, required this.time});

  final IconData icon;
  final String time;

  @override
  Widget build(BuildContext context) {
    final color = context.color.text.secondary;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: color),
        Gap(context.dimensions.spacing.s4),
        Text(time, style: context.textStyle.bodySmall.copyWith(color: color)),
      ],
    );
  }
}

class _LocationRow extends StatelessWidget {
  const _LocationRow({required this.visit});

  final SupervisorVisitEntity visit;

  @override
  Widget build(BuildContext context) {
    final verified = visit.locationVerified ?? false;
    final color = verified ? context.color.success : context.color.error;
    final distance = visit.checkInDistanceMeters;

    return Row(
      children: [
        Icon(
          verified ? Icons.check_circle_outline : Icons.error_outline,
          size: 14,
          color: color,
        ),
        Gap(context.dimensions.spacing.s4),
        Expanded(
          child: Text(
            [
              verified
                  ? context.locale.locationVerified
                  : context.locale.locationNotVerified,
              if (distance != null)
                context.locale.distanceAway(distance.round().toString()),
            ].join(' · '),
            style: context.textStyle.bodySmall.copyWith(color: color),
          ),
        ),
      ],
    );
  }
}

class _ScoreRow extends StatelessWidget {
  const _ScoreRow({required this.visit});

  final SupervisorVisitEntity visit;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final percentage = visit.scorePercentage ?? 0;
    final passed = visit.hasPassed;
    final color = switch (passed) {
      true => context.color.success,
      false => context.color.error,
      null => context.color.primary,
    };
    final score = visit.totalScore != null && visit.maxScore != null
        ? '${_trim(visit.totalScore!)} / ${_trim(visit.maxScore!)} · '
        : '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$score${_trim(percentage)}%',
              style: context.textStyle.bodySmall.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (visit.passMark != null)
              Text(
                context.locale.passMarkValue(_trim(visit.passMark!)),
                style: context.textStyle.bodySmall.copyWith(
                  color: context.color.text.secondary,
                ),
              ),
          ],
        ),
        Gap(spacing.s4),
        ClipRRect(
          borderRadius: BorderRadius.circular(context.dimensions.radius.r6),
          child: LinearProgressIndicator(
            value: (percentage / 100).clamp(0, 1).toDouble(),
            minHeight: 6,
            color: color,
            backgroundColor: context.color.borderSubtle,
          ),
        ),
      ],
    );
  }

  /// 85.0 reads as "85", 82.5 stays "82.5".
  String _trim(num value) =>
      value % 1 == 0 ? value.toInt().toString() : value.toStringAsFixed(1);
}
