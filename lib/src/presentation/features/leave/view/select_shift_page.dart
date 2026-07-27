part of 'apply_leave_page.dart';

class SelectShiftPage extends ConsumerWidget {
  const SelectShiftPage({
    super.key,
    required this.date,
    required this.partnerId,
  });

  final String date;
  final int partnerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shiftsState = ref.watch(
      leaveShiftsProvider(partnerId: partnerId, date: date),
    );

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: context.pop,
          child: Row(
            children: [
              Icon(
                Icons.chevron_left_rounded,
                color: context.color.primary,
                size: 28,
              ),
              Text(
                context.locale.back,
                style: context.textStyle.labelXl.copyWith(
                  color: context.color.primary,
                ),
              ),
            ],
          ),
        ),
        leadingWidth: 100,
        title: Headline2xlTinyText(context.locale.selectShift),
        centerTitle: true,
        backgroundColor: context.color.onPrimary,
        surfaceTintColor: Colors.transparent,
      ),
      body: shiftsState.when(
        loading: () => const _ShiftListShimmer(),
        error: (e, _) => Center(
          child: Padding(
            padding: EdgeInsets.all(context.dimensions.spacing.s24),
            child: Text(
              e.toString(),
              style: context.textStyle.bodyMedium.copyWith(
                color: context.color.text.secondary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        data: (shifts) => shifts.isEmpty
            ? Center(
                child: Text(
                  context.locale.noShiftsAvailableForDate,
                  style: context.textStyle.bodyMedium.copyWith(
                    color: context.color.text.secondary,
                  ),
                ),
              )
            : _SelectShiftBody(shifts: shifts),
      ),
    );
  }
}

