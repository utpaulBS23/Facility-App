part of '../view/shift_tab.dart';

class _SlotDetailsActionListener extends ConsumerWidget {
  const _SlotDetailsActionListener({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(unassignShiftSlotProvider, (_, next) {
      if (next is AsyncData && next.hasValue) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.locale.staffUnassignedSuccessfully)),
        );
        ref.read(shiftSlotsProvider.notifier).refresh();
      } else if (next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error.localizedMessage(context))),
        );
      }
    });

    ref.listen(makeSlotLeadProvider, (_, next) {
      if (next is AsyncData && next.hasValue) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.locale.slotLeadUpdatedSuccessfully)),
        );
        ref.read(shiftSlotsProvider.notifier).refresh();
      } else if (next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error.localizedMessage(context))),
        );
      }
    });

    return child;
  }
}
