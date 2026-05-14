part of 'shift_tab.dart';

class ShiftDetailsPage extends StatelessWidget {
  const ShiftDetailsPage({super.key, required this.entity});

  final ShiftEntity entity;

  bool get _showCheckOutButton =>
      entity.checkInTime != null && entity.checkOutTime == null;

  void _onCheckOut(BuildContext context) {
    context.pushNamed(Routes.shiftCheckOut, extra: entity.id);
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final padding = context.dimensions.padding;

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
        title: Headline2xlTinyText(context.locale.shiftDetails),
        centerTitle: true,
        backgroundColor: context.color.onPrimary,
        surfaceTintColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Expanded(child: _ShiftDetailsBody(entity: entity)),
          if (_showCheckOutButton)
            Padding(
              padding: EdgeInsets.fromLTRB(
                padding.p16,
                spacing.s16,
                padding.p16,
                spacing.s32,
              ),
              child: SizedBox(
                width: double.infinity,
                height: spacing.s44,
                child: FilledButton.icon(
                  onPressed: () => _onCheckOut(context),
                  icon: const Icon(Icons.logout_rounded),
                  label: Text(context.locale.checkOut),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
