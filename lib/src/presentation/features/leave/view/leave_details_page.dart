part of 'apply_leave_page.dart';

class LeaveDetailsPage extends ConsumerWidget {
  const LeaveDetailsPage({super.key, required this.request});

  final LeaveRequestEntity request;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = context.dimensions.spacing;
    final color = context.color;
    final textStyle = context.textStyle;

    final isActionable = request.canAction;

    return Scaffold(
      backgroundColor: color.scaffoldBackground,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Row(
            children: [
              Icon(Icons.chevron_left_rounded, color: color.primary, size: 28),
              Text(
                context.locale.back,
                style: textStyle.labelXl.copyWith(color: color.primary),
              ),
            ],
          ),
        ),
        leadingWidth: 100,
        title: Headline2xlTinyText(context.locale.leaveDetails),
        centerTitle: true,
        backgroundColor: color.onPrimary,
        surfaceTintColor: Colors.transparent,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(spacing.s16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _LeaveDetailHeaderCard(request: request),
                  Gap(spacing.s12),
                  _LeaveDetailInfoSection(request: request),
                  Gap(spacing.s12),
                  _LeaveDetailShiftSection(request: request),
                  Gap(spacing.s12),
                  _LeaveStatusTimeline(request: request),
                ],
              ),
            ),
          ),
          if (isActionable)
            Container(
              padding: EdgeInsets.fromLTRB(
                spacing.s16,
                spacing.s12,
                spacing.s16,
                spacing.s20,
              ),
              decoration: BoxDecoration(
                color: color.onPrimary,
                boxShadow: [
                  BoxShadow(
                    color: color.shadow.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
                border: Border(top: BorderSide(color: color.borderSubtle)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: () async {
                        final success = await ref
                            .read(leaveRequestActionProvider.notifier)
                            .approve(request.id);
                        if (success && context.mounted) context.pop();
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: color.primary,
                        foregroundColor: color.onPrimary,
                        minimumSize: Size(double.infinity, spacing.s44),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            context.dimensions.radius.r10,
                          ),
                        ),
                      ),
                      child: Text(context.locale.approved),
                    ),
                  ),
                  Gap(spacing.s12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        final success = await ref
                            .read(leaveRequestActionProvider.notifier)
                            .reject(request.id);
                        if (success && context.mounted) context.pop();
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: color.primary,
                        side: BorderSide(color: color.primary),
                        minimumSize: Size(double.infinity, spacing.s44),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            context.dimensions.radius.r10,
                          ),
                        ),
                      ),
                      child: Text(context.locale.rejection),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
