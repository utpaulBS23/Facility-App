part of '../view/login_page.dart';

/// Lists saved accounts with a Remove action for each.
class _ManageAccountsView extends StatelessWidget {
  const _ManageAccountsView({
    required this.accounts,
    required this.onRemove,
    required this.onAddAnother,
    required this.onDone,
  });

  final List<SavedAccountEntity> accounts;
  final ValueChanged<SavedAccountEntity> onRemove;
  final VoidCallback onAddAnother;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final dimensions = context.dimensions;
    final textStyle = context.textStyle;

    return ListView(
      padding: EdgeInsets.all(dimensions.padding.p16),
      children: [
        SizedBox(height: dimensions.spacing.s24),
        Row(
          children: [
            Expanded(
              child: Text(
                context.locale.manageAccounts,
                style: textStyle.headlineMedium.copyWith(
                  color: colors.text.primary,
                ),
              ),
            ),
            TextButton(onPressed: onDone, child: Text(context.locale.done)),
          ],
        ),
        SizedBox(height: dimensions.spacing.s4),
        Text(
          context.locale.manageAccountsHelper,
          style: textStyle.bodySmall.copyWith(color: colors.text.secondary),
        ),
        SizedBox(height: dimensions.spacing.s16),
        Container(
          padding: EdgeInsets.symmetric(horizontal: dimensions.padding.p16),
          decoration: _loginCardDecoration(context),
          child: Column(
            children: [
              for (var i = 0; i < accounts.length; i++) ...[
                if (i > 0) Divider(height: 1, color: colors.borderSubtle),
                _ManageRow(
                  account: accounts[i],
                  onRemove: () => onRemove(accounts[i]),
                ),
              ],
            ],
          ),
        ),
        SizedBox(height: dimensions.spacing.s24),
        Center(
          child: TextButton.icon(
            onPressed: onAddAnother,
            icon: const Icon(Icons.add),
            label: Text(context.locale.addAnotherAccount),
          ),
        ),
      ],
    );
  }
}

class _ManageRow extends StatelessWidget {
  const _ManageRow({required this.account, required this.onRemove});

  final SavedAccountEntity account;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final dimensions = context.dimensions;
    final textStyle = context.textStyle;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: dimensions.spacing.s12),
      child: Row(
        children: [
          AccountAvatar(
            name: account.name,
            uid: account.uid,
            thumbnail: account.thumbnail,
          ),
          SizedBox(width: dimensions.spacing.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  account.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textStyle.titleMedium.copyWith(
                    color: colors.text.primary,
                  ),
                ),
                Text(
                  account.uid,
                  style: textStyle.bodySmall.copyWith(
                    color: colors.text.secondary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: dimensions.spacing.s8),
          OutlinedButton.icon(
            onPressed: onRemove,
            icon: Icon(Icons.delete_outline, size: dimensions.spacing.s16),
            label: Text(context.locale.remove),
            style: OutlinedButton.styleFrom(
              foregroundColor: colors.primary,
              side: BorderSide(color: colors.primary),
              minimumSize: Size(0, dimensions.spacing.s36),
              padding: EdgeInsets.symmetric(horizontal: dimensions.spacing.s12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(dimensions.radius.r10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
