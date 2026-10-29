part of '../view/login_page.dart';

/// Bottom sheet listing every saved account, plus a link to manage them.
///
/// Each callback runs after the sheet has closed.
Future<void> _showAccountPickerSheet(
  BuildContext context, {
  required List<SavedAccountEntity> accounts,
  required String? selectedUid,
  required ValueChanged<SavedAccountEntity> onPick,
  required VoidCallback onManage,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: context.color.onPrimary,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(context.dimensions.radius.r20),
      ),
    ),
    builder: (sheetContext) {
      void closeThen(VoidCallback action) {
        Navigator.of(sheetContext).pop();
        action();
      }

      return _AccountPickerSheet(
        accounts: accounts,
        selectedUid: selectedUid,
        onPick: (account) => closeThen(() => onPick(account)),
        onManage: () => closeThen(onManage),
      );
    },
  );
}

class _AccountPickerSheet extends StatelessWidget {
  const _AccountPickerSheet({
    required this.accounts,
    required this.selectedUid,
    required this.onPick,
    required this.onManage,
  });

  final List<SavedAccountEntity> accounts;
  final String? selectedUid;
  final ValueChanged<SavedAccountEntity> onPick;
  final VoidCallback onManage;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final dimensions = context.dimensions;

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          dimensions.padding.p16,
          dimensions.spacing.s12,
          dimensions.padding.p16,
          dimensions.padding.p16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: dimensions.spacing.s40,
                height: dimensions.spacing.s4,
                decoration: BoxDecoration(
                  color: colors.border,
                  borderRadius: BorderRadius.circular(dimensions.radius.r12),
                ),
              ),
            ),
            SizedBox(height: dimensions.spacing.s16),
            Text(
              context.locale.chooseAnAccount,
              style: context.textStyle.titleMedium.copyWith(
                color: colors.text.primary,
              ),
            ),
            SizedBox(height: dimensions.spacing.s12),
            for (final account in accounts) ...[
              _AccountRow(
                account: account,
                isSelected: account.uid == selectedUid,
                onTap: () => onPick(account),
              ),
              SizedBox(height: dimensions.spacing.s12),
            ],
            Center(
              child: TextButton(
                onPressed: onManage,
                child: Text(context.locale.manageAccounts),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AccountRow extends StatelessWidget {
  const _AccountRow({
    required this.account,
    required this.isSelected,
    required this.onTap,
  });

  final SavedAccountEntity account;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final dimensions = context.dimensions;
    final textStyle = context.textStyle;
    final radius = BorderRadius.circular(dimensions.radius.r12);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Container(
          padding: EdgeInsets.all(dimensions.spacing.s12),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? colors.borderBrand : colors.border,
            ),
            borderRadius: radius,
          ),
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
              Icon(
                isSelected ? Icons.check : Icons.chevron_right,
                color: isSelected ? colors.primary : colors.icon,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
