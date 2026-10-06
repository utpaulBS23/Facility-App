part of '../view/shift_tab.dart';

/// Route target of `/shift-details/:facilityId/:date/:slotId`.
///
/// WHY it loads: the route carries only ids, so a deep link or another screen
/// (the dashboard's staff shortage) can open a slot without holding the slot
/// object. The slot is taken from the day's list when that is already loaded
/// (the Shift tab opened it), else the day is fetched first.
class SlotDetailsLoader extends ConsumerStatefulWidget {
  const SlotDetailsLoader({
    super.key,
    required this.facilityId,
    required this.date,
    required this.slotId,
  });

  final int facilityId;

  /// `yyyy-MM-dd`.
  final String date;
  final int slotId;

  @override
  ConsumerState<SlotDetailsLoader> createState() => _SlotDetailsLoaderState();
}

class _SlotDetailsLoaderState extends ConsumerState<SlotDetailsLoader> {
  // WHY kept: a later refetch of the day (after assign / unassign) clears the
  // provider while it loads. The details page keeps showing its last slot
  // through that, so this must not swap it for a spinner.
  ShiftSlotEntity? _slot;
  bool _requested = false;
  Failure? _failure;

  @override
  void initState() {
    super.initState();
    // WHY post-frame: writing to shiftSlotsProvider while the tree builds
    // throws, same as the Shift tab's own first fetch.
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  ShiftSlotEntity? _find() =>
      ref.read(shiftSlotsProvider).valueOrNull?.findSlot(widget.slotId);

  Future<void> _load() async {
    if (!mounted) return;
    if (_find() != null) {
      setState(() => _requested = true);
      return;
    }

    setState(() {
      _requested = false;
      _failure = null;
    });
    final failure = await ref
        .read(shiftSlotsProvider.notifier)
        .fetch(date: widget.date, facilityId: widget.facilityId);
    if (!mounted) return;
    setState(() {
      _requested = true;
      _failure = failure;
    });
  }

  @override
  Widget build(BuildContext context) {
    final live = ref
        .watch(shiftSlotsProvider)
        .valueOrNull
        ?.findSlot(widget.slotId);
    final slot = live ?? _slot;
    if (live != null) _slot = live;
    if (slot != null) return SlotDetailsPage(slot: slot);

    final failure = _failure;

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: DetailAppBar(title: context.locale.shiftDetails),
      body: !_requested
          ? const Center(child: CircularProgressIndicator())
          : AppErrorWidget(
              message:
                  failure?.localizedMessage(context) ??
                  context.locale.somethingWentWrong,
              onRetry: _load,
            ),
    );
  }
}
