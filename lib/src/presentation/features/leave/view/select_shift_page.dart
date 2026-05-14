part of 'apply_leave_page.dart';

class SelectShiftPage extends StatelessWidget {
  const SelectShiftPage({super.key, required this.shifts});

  final List<ShiftEntity> shifts;

  @override
  Widget build(BuildContext context) {
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
      body: _SelectShiftBody(shifts: shifts),
    );
  }
}
