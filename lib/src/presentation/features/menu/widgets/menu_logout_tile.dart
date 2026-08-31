part of '../view/menu_page.dart';

class _LogoutTile extends StatelessWidget {
  const _LogoutTile({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(context.spacing.s4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: context.padding.p16,
            vertical: context.spacing.s16,
          ),
          decoration: BoxDecoration(
            color: context.color.onPrimary,
            border: Border.all(color: context.color.primary),
            borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
          ),
          child: Row(
            children: [
              Icon(
                Icons.logout_rounded,
                size: context.spacing.s20,
                color: context.color.primary,
              ),
              Gap(context.spacing.s12),
              Expanded(
                child: Text(
                  context.locale.logout,
                  style: context.textStyle.bodyLarge.copyWith(
                    color: context.color.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
