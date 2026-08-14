part of 'shift_tab.dart';

class ShiftDetailsPage extends StatelessWidget {
  const ShiftDetailsPage({super.key, required this.entity});

  final ShiftEntity entity;

  bool get _showCheckOutButton =>
      entity.checkInTime != null && entity.checkOutTime == null;

  void _onCheckOut(BuildContext context) {
    context.pushNamed(Routes.shiftCheckOut, extra: entity.id);
  }

  void _onUpdateStock(BuildContext context) {
    context.pushNamed(
      Routes.updateStock,
      extra: UpdateStockPageArgs(
        facilityId: entity.facility.id,
        shiftAssignmentId: entity.id,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.dimensions.spacing;
    final padding = context.dimensions.padding;

    return Scaffold(
      backgroundColor: context.color.scaffoldBackground,
      appBar: AppBar(
        leading: const AppBackButton(),
        leadingWidth: AppBackButton.width,
        title: Headline2xlTinyText(context.locale.shiftDetails),
        centerTitle: true,
        backgroundColor: context.color.onPrimary,
        surfaceTintColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Expanded(child: _ShiftDetailsBody(entity: entity)),
          SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                padding.p16,
                spacing.s16,
                padding.p16,
                spacing.s16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PermissionGate(
                    permissions: const [UserPermission.shiftStockCountCreate],
                    child: SizedBox(
                      width: double.infinity,
                      height: spacing.s44,
                      child: OutlinedButton.icon(
                        onPressed: () => _onUpdateStock(context),
                        icon: const Icon(Icons.inventory_2_outlined),
                        label: Text(context.locale.updateStockBalances),
                      ),
                    ),
                  ),
                  if (_showCheckOutButton) ...[
                    Gap(spacing.s12),
                    PermissionGate(
                      permissions: const [UserPermission.attendanceCheckOut],
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
