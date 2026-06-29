part of '../view/my_visits_page.dart';

class _VisitEmptyState extends StatelessWidget {
  const _VisitEmptyState({required this.tab});

  final _VisitTab tab;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(spacing.s24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.event_available_outlined,
              size: 48,
              color: context.color.icon,
            ),
            Gap(spacing.s16),
            Text(
              context.locale.noVisitsFound,
              style: context.textStyle.bodyMedium.copyWith(
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
