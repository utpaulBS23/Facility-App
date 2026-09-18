part of '../view/occurrence_page.dart';

class _OccurrenceStatusFilterSheet extends StatelessWidget {
  const _OccurrenceStatusFilterSheet({required this.selectedFilter});

  final _OccurrenceStatusFilter selectedFilter;

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final radius = context.dimensions.radius;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.75,
      ),
      decoration: BoxDecoration(
        color: context.color.scaffoldBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(radius.r12)),
      ),
      // WHY Material: ListTile paints its background/ink splashes on the
      // nearest Material ancestor. Without this, the outer Container's own
      // BoxDecoration color sits on top and hides them (Flutter's own
      // "ListTile background color or ink splashes may be invisible"
      // assertion).
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Gap(spacing.s12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: context.color.borderSubtle,
                borderRadius: BorderRadius.circular(radius.r4),
              ),
            ),
            Gap(spacing.s16),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: spacing.s16),
              child: LabelLargeText(context.locale.status),
            ),
            Gap(spacing.s8),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.fromLTRB(
                  spacing.s16,
                  0,
                  spacing.s16,
                  spacing.s16,
                ),
                itemCount: _OccurrenceStatusFilter.values.length,
                separatorBuilder: (_, _) => Gap(spacing.s8),
                itemBuilder: (context, index) {
                  final filter = _OccurrenceStatusFilter.values[index];
                  final isSelected = filter == selectedFilter;
                  return ListTile(
                    onTap: () => Navigator.of(context).pop(filter),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(radius.r10),
                      side: BorderSide(
                        color: isSelected
                            ? context.color.primary
                            : context.color.borderSubtle,
                      ),
                    ),
                    title: Text(_occurrenceStatusFilterLabel(context, filter)),
                    trailing: isSelected
                        ? Icon(
                            Icons.check_circle_rounded,
                            color: context.color.primary,
                          )
                        : null,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
