part of '../view/request_details_page.dart';

class _DispatchActionButton extends ConsumerWidget {
  const _DispatchActionButton({required this.onDispatch});

  final VoidCallback onDispatch;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = context.dimensions.spacing;
    final color = context.color;
    final isBusy = ref.watch(supplyRequestActionProvider).isLoading;

    return PermissionGate(
      permissions: const [UserPermission.deliveryDispatch],
      child: Container(
        padding: EdgeInsets.all(spacing.s16),
        decoration: BoxDecoration(
          color: color.onPrimary,
          border: Border(top: BorderSide(color: color.borderSubtle)),
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: spacing.s44,
            child: FilledButton(
              onPressed: isBusy ? null : onDispatch,
              child: isBusy
                  ? SizedBox(
                      width: spacing.s20,
                      height: spacing.s20,
                      child: CircularProgressIndicator(
                        strokeWidth: spacing.s2,
                        color: color.onPrimary,
                      ),
                    )
                  : Text(context.locale.dispatch),
            ),
          ),
        ),
      ),
    );
  }
}
