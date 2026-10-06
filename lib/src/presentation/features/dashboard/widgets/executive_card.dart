import 'package:flutter/material.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../core/theme/theme.dart';
import 'facility_row.dart';

/// An executive (supervisor-level manager) with their monthly target and the
/// facilities they run.
class ExecutiveCard extends StatelessWidget {
  const ExecutiveCard({
    super.key,
    required this.name,
    required this.facilityCountText,
    required this.targetText,
    required this.facilities,
  });

  final String name;

  /// e.g. "3".
  final String facilityCountText;

  /// e.g. "৳ 42,000".
  final String targetText;
  final List<FacilityRow> facilities;

  /// Up to two initials of [name].
  static String initialsOf(String name) {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '?';
    final first = parts.first.characters.first;
    final second = parts.length > 1 ? parts[1].characters.first : '';
    return (first + second).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.color;
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(spacing.s16),
      decoration: BoxDecoration(
        color: c.onPrimary,
        borderRadius: BorderRadius.circular(radius.r16),
        border: Border.all(color: c.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: c.brandAccent,
                  borderRadius: BorderRadius.circular(radius.r12),
                ),
                child: Text(
                  initialsOf(name),
                  style: context.textStyle.labelLarge.copyWith(
                    color: c.text.brand,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(width: spacing.s12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: context.textStyle.labelXl.copyWith(
                        color: c.text.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      context.locale.executive,
                      style: context.textStyle.bodySmall.copyWith(
                        color: c.text.secondary,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    facilityCountText,
                    style: context.textStyle.titleLarge.copyWith(
                      color: c.text.brand,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    context.locale.totalFacility,
                    style: context.textStyle.labelSmall.copyWith(
                      color: c.text.secondary,
                      letterSpacing: 0,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: spacing.s14),
          Container(
            padding: EdgeInsets.all(spacing.s12),
            decoration: BoxDecoration(
              color: c.subtle,
              borderRadius: BorderRadius.circular(radius.r12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.locale.monthlyTarget,
                  style: context.textStyle.bodySmall.copyWith(
                    color: c.text.secondary,
                  ),
                ),
                Text(
                  targetText,
                  style: context.textStyle.labelXl.copyWith(
                    color: c.text.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          for (final facility in facilities) ...[
            SizedBox(height: spacing.s14),
            Container(
              padding: EdgeInsets.only(top: spacing.s10),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: c.borderSubtle)),
              ),
              child: facility,
            ),
          ],
        ],
      ),
    );
  }
}
