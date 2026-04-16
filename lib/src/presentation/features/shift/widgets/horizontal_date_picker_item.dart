part of '../view/shift_page.dart';

class _DatePickerItem extends StatelessWidget {
  const _DatePickerItem({
    required this.date,
    required this.isSelected,
    required this.onTap,
    required this.onContextReady,
  });

  final DateTime date;
  final bool isSelected;
  final VoidCallback onTap;
  // WHY: Callback lets the parent state register this item's BuildContext for
  // Scrollable.ensureVisible to scroll the initially selected date into view.
  final ValueSetter<BuildContext> onContextReady;

  @override
  Widget build(BuildContext context) {
    onContextReady(context);

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(DateFormat('E').format(date)),
            const SizedBox(height: 5),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14.5,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected
                      ? context.color.primary
                      : context.color.onPrimary,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(DateFormat('d').format(date)),
            ),
          ],
        ),
      ),
    );
  }
}
