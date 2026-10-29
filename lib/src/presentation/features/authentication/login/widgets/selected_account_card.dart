part of '../view/login_page.dart';

/// The last signed-in account. Tapping the body signs in; the trailing chevron
/// opens the account picker.
class _SelectedAccountCard extends StatelessWidget {
  const _SelectedAccountCard({
    required this.account,
    required this.onSignIn,
    required this.onOpenPicker,
  });

  final SavedAccountEntity account;
  final VoidCallback onSignIn;
  final VoidCallback onOpenPicker;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final dimensions = context.dimensions;
    final radius = BorderRadius.circular(dimensions.radius.r12);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: colors.border),
        borderRadius: radius,
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: onSignIn,
              borderRadius: radius,
              child: Padding(
                padding: EdgeInsets.all(dimensions.spacing.s12),
                child: Row(
                  children: [
                    AccountAvatar(
                      name: account.name,
                      uid: account.uid,
                      thumbnail: account.thumbnail,
                    ),
                    SizedBox(width: dimensions.spacing.s12),
                    Expanded(child: _AccountLabel(account: account)),
                  ],
                ),
              ),
            ),
          ),
          InkWell(
            onTap: onOpenPicker,
            borderRadius: radius,
            child: SizedBox(
              width: dimensions.spacing.s48,
              height: dimensions.spacing.s56,
              child: Icon(Icons.keyboard_arrow_down, color: colors.icon),
            ),
          ),
        ],
      ),
    );
  }
}

class _AccountLabel extends StatelessWidget {
  const _AccountLabel({required this.account});

  final SavedAccountEntity account;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final textStyle = context.textStyle;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          account.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: textStyle.titleMedium.copyWith(color: colors.text.primary),
        ),
        Text(
          account.uid,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: textStyle.bodySmall.copyWith(color: colors.text.secondary),
        ),
      ],
    );
  }
}
