import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/text/typography.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final locale = context.locale;

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: AppBar(
        title: DisplaySmallText(locale.dashboard),
        titleSpacing: spacing.s16,
        backgroundColor: context.color.onPrimary,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(spacing.s16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section
              _WelcomeCard(context: context),
              Gap(spacing.s20),

              // Monthly Expenditure Summary
              _ExpenditureSummary(context: context),
              Gap(spacing.s20),

              // Staff Shortage Alert
              _StaffShortageAlert(context: context),
              Gap(spacing.s20),

              // Facilities Overview
              _FacilitiesOverview(context: context),
              Gap(spacing.s20),

              // Air Quality Section
              _AirQualitySection(context: context),
              Gap(spacing.s20),

              // Cost Summary
              _CostSummarySection(context: context),
              Gap(spacing.s20),
            ],
          ),
        ),
      ),
    );
  }
}

class _WelcomeCard extends StatelessWidget {
  const _WelcomeCard({required this.context});

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabelLargeText('Welcome, Rahium'),
        Gap(spacing.s8),
        BodySmallText(
          'Monthly expenditure summary',
          color: context.color.text.secondary,
        ),
      ],
    );
  }
}

class _ExpenditureSummary extends StatelessWidget {
  const _ExpenditureSummary({required this.context});

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;

    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: context.color.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(radius.r12),
            ),
            padding: EdgeInsets.all(spacing.s16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.check_circle_outline, color: context.color.success, size: 24),
                Gap(spacing.s8),
                BodySmallText('Check In', color: context.color.text.secondary),
                Gap(spacing.s4),
                DisplaySmallText('---', color: context.color.success),
              ],
            ),
          ),
        ),
        Gap(spacing.s12),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: context.color.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(radius.r12),
            ),
            padding: EdgeInsets.all(spacing.s16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.close_rounded, color: context.color.error, size: 24),
                Gap(spacing.s8),
                BodySmallText('Check Out', color: context.color.text.secondary),
                Gap(spacing.s4),
                DisplaySmallText('---', color: context.color.error),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _StaffShortageAlert extends StatelessWidget {
  const _StaffShortageAlert({required this.context});

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;

    return Container(
      decoration: BoxDecoration(
        color: context.color.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(radius.r12),
        border: Border.all(color: context.color.warning.withValues(alpha: 0.3)),
      ),
      padding: EdgeInsets.all(spacing.s16),
      child: Row(
        children: [
          Container(
            width: spacing.s40,
            height: spacing.s40,
            decoration: BoxDecoration(
              color: context.color.warning,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: LabelLargeText('2', color: context.color.onPrimary),
          ),
          Gap(spacing.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LabelLargeText('Staff shortage'),
                Gap(spacing.s4),
                BodySmallText(
                  '2 staff shortage not assigned to the facility',
                  color: context.color.text.secondary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FacilitiesOverview extends StatelessWidget {
  const _FacilitiesOverview({required this.context});

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabelLargeText('Facilities'),
        Gap(spacing.s12),
        _FacilityCard(
          context: context,
          name: 'Mirpur-10 Public Toilet Complex',
          total: 8,
          open: 1,
          inProcess: 3,
          close: 1,
          uptimeRate: 63,
        ),
        Gap(spacing.s12),
        _FacilityCard(
          context: context,
          name: 'Hammondi Market Restrooms',
          total: 5,
          open: 2,
          inProcess: 1,
          close: 2,
          uptimeRate: 72,
        ),
      ],
    );
  }
}

class _FacilityCard extends StatelessWidget {
  const _FacilityCard({
    required this.context,
    required this.name,
    required this.total,
    required this.open,
    required this.inProcess,
    required this.close,
    required this.uptimeRate,
  });

  final BuildContext context;
  final String name;
  final int total;
  final int open;
  final int inProcess;
  final int close;
  final int uptimeRate;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;

    return Container(
      decoration: BoxDecoration(
        color: context.color.onPrimary,
        borderRadius: BorderRadius.circular(radius.r12),
        border: Border.all(color: context.color.borderSubtle),
      ),
      padding: EdgeInsets.all(spacing.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.location_on_rounded, color: context.color.primary, size: 20),
              Gap(spacing.s8),
              Expanded(child: LabelLargeText(name)),
              Icon(Icons.arrow_forward_ios_rounded, size: 16, color: context.color.text.secondary),
            ],
          ),
          Gap(spacing.s16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatItem(context: context, value: total.toString(), label: 'Total'),
              _StatItem(context: context, value: open.toString(), label: 'Open', color: context.color.success),
              _StatItem(context: context, value: inProcess.toString(), label: 'In process', color: context.color.warning),
              _StatItem(context: context, value: close.toString(), label: 'Close', color: context.color.error),
            ],
          ),
          Gap(spacing.s16),
          BodySmallText('Uptime rate', color: context.color.text.secondary),
          Gap(spacing.s8),
          ClipRRect(
            borderRadius: BorderRadius.circular(radius.r4),
            child: LinearProgressIndicator(
              value: uptimeRate / 100,
              minHeight: spacing.s6,
              backgroundColor: context.color.borderSubtle,
              color: context.color.primary,
            ),
          ),
          Gap(spacing.s8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BodySmallText('', color: context.color.text.secondary),
              BodySmallText('${uptimeRate}%', color: context.color.text.secondary),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.context,
    required this.value,
    required this.label,
    this.color,
  });

  final BuildContext context;
  final String value;
  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Column(
      children: [
        Container(
          width: spacing.s40,
          height: spacing.s40,
          decoration: BoxDecoration(
            color: (color ?? context.color.text.secondary).withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: LabelLargeText(
            value,
            color: color ?? context.color.text.secondary,
          ),
        ),
        Gap(spacing.s4),
        BodySmallText(label, color: context.color.text.secondary),
      ],
    );
  }
}

class _AirQualitySection extends StatelessWidget {
  const _AirQualitySection({required this.context});

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.air_rounded, color: context.color.primary, size: 20),
            Gap(spacing.s8),
            LabelLargeText('Air Quality'),
          ],
        ),
        Gap(spacing.s12),
        _AirQualityItem(context: context, facility: 'Mirpur-10 Public Toilet', aqi: 10, status: 'Good'),
        Gap(spacing.s12),
        _AirQualityItem(context: context, facility: 'Hammondi Park Restroom', aqi: 35, status: 'Medium'),
        Gap(spacing.s12),
        _AirQualityItem(context: context, facility: 'Gulshan-2 Market Toilet', aqi: 42, status: 'Bad'),
      ],
    );
  }
}

class _AirQualityItem extends StatelessWidget {
  const _AirQualityItem({
    required this.context,
    required this.facility,
    required this.aqi,
    required this.status,
  });

  final BuildContext context;
  final String facility;
  final int aqi;
  final String status;

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Good':
        return context.color.success;
      case 'Medium':
        return context.color.warning;
      case 'Bad':
        return context.color.error;
      default:
        return context.color.text.secondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BodySmallText(facility),
              Gap(spacing.s4),
              BodySmallText('AQI: $aqi', color: context.color.text.secondary),
            ],
          ),
        ),
        Gap(spacing.s12),
        Container(
          padding: EdgeInsets.symmetric(horizontal: spacing.s12, vertical: spacing.s6),
          decoration: BoxDecoration(
            color: _getStatusColor(status).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(spacing.s4),
          ),
          child: Row(
            children: [
              Container(
                width: spacing.s8,
                height: spacing.s8,
                decoration: BoxDecoration(
                  color: _getStatusColor(status),
                  shape: BoxShape.circle,
                ),
              ),
              Gap(spacing.s4),
              BodySmallText(status, color: _getStatusColor(status)),
            ],
          ),
        ),
        Icon(Icons.arrow_forward_ios_rounded, size: 14, color: context.color.text.secondary),
      ],
    );
  }
}

class _CostSummarySection extends StatelessWidget {
  const _CostSummarySection({required this.context});

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.receipt_long_rounded, color: context.color.primary, size: 20),
                Gap(spacing.s8),
                LabelLargeText('Cost Summary for Each Facility'),
              ],
            ),
            BodySmallText('View', color: context.color.primary),
          ],
        ),
        Gap(spacing.s12),
        _CostItem(
          context: context,
          facility: 'Hammondi Market Restrooms',
          acquired: '৳ 12,500',
          target: '৳ 15,000',
        ),
        Gap(spacing.s12),
        _CostItem(
          context: context,
          facility: 'Banani Square Restrooms',
          acquired: '৳ 9,750',
          target: '৳ 12,000',
        ),
      ],
    );
  }
}

class _CostItem extends StatelessWidget {
  const _CostItem({
    required this.context,
    required this.facility,
    required this.acquired,
    required this.target,
  });

  final BuildContext context;
  final String facility;
  final String acquired;
  final String target;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.location_on_rounded, color: context.color.primary, size: 16),
                  Gap(spacing.s4),
                  Expanded(child: BodySmallText(facility)),
                ],
              ),
              Gap(spacing.s8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BodySmallText('Acquired:', color: context.color.text.secondary),
                      BodySmallText(acquired),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BodySmallText('Target', color: context.color.text.secondary),
                      BodySmallText(target),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        Icon(Icons.arrow_forward_ios_rounded, size: 14, color: context.color.text.secondary),
      ],
    );
  }
}
