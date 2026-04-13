part of 'attendance_page.dart';

class AttendanceDetailsPage extends ConsumerWidget {
  const AttendanceDetailsPage({super.key, required this.attendanceId});

  final String attendanceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(attendanceDetailProvider(attendanceId));

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: AppBar(
        // WHY: iOS-style back button with label text matches the Figma design.
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
        title: Headline2xlTinyText(context.locale.attendanceDetails),
        centerTitle: true,
        backgroundColor: context.color.onPrimary,
        surfaceTintColor: Colors.transparent,
      ),
      body: state.when(
        data: (detail) => _AttendanceDetailsBody(detail: detail),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text(err.toString())),
      ),
    );
  }
}
