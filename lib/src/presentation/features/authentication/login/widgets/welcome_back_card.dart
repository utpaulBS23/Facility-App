part of '../view/login_page.dart';

/// The "Welcome back" card: the last signed-in account with a dropdown for the
/// others, plus a link to manage them.
class _WelcomeBackCard extends StatelessWidget {
  const _WelcomeBackCard({
    required this.account,
    required this.onSignIn,
    required this.onOpenPicker,
    required this.onUseAnother,
    required this.onManage,
  });

  final SavedAccountEntity account;
  final VoidCallback onSignIn;
  final VoidCallback onOpenPicker;
  final VoidCallback onUseAnother;
  final VoidCallback onManage;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final dimensions = context.dimensions;

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(dimensions.padding.p20),
          decoration: _loginCardDecoration(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeadlineLargeText(context.locale.savedAccountsWelcomeBack),
              Gap(dimensions.spacing.s6),
              BodyRegularText(
                context.locale.savedAccountsChoose,
                color: colors.text.secondary,
              ),
              Gap(dimensions.spacing.s16),
              _SelectedAccountCard(
                account: account,
                onSignIn: onSignIn,
                onOpenPicker: onOpenPicker,
              ),
              Gap(dimensions.spacing.s12),
              _UseAnotherRow(onTap: onUseAnother),
            ],
          ),
        ),
        Gap(dimensions.spacing.s16),
        TextButton(
          onPressed: onManage,
          child: Text(context.locale.manageAccounts),
        ),
        Gap(dimensions.spacing.s8),
        BodySmallText(
          context.locale.accountsSavedOnDeviceOnly,
          color: colors.text.secondary,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

/// Dashed brand-colored outline, as in the design.
class _UseAnotherRow extends StatelessWidget {
  const _UseAnotherRow({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final dimensions = context.dimensions;
    final radius = dimensions.radius.r12;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(radius),
      child: CustomPaint(
        painter: _DashedBorderPainter(color: colors.primary, radius: radius),
        child: SizedBox(
          height: dimensions.spacing.s48,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add, color: colors.primary, size: dimensions.spacing.s20),
              SizedBox(width: dimensions.spacing.s8),
              Text(
                context.locale.useAnotherAccount,
                style: context.textStyle.labelXl.copyWith(
                  color: colors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  const _DashedBorderPainter({required this.color, required this.radius});

  final Color color;
  final double radius;

  static const _dash = 5.0;
  static const _gap = 4.0;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(radius)),
      );

    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        canvas.drawPath(metric.extractPath(distance, distance + _dash), paint);
        distance += _dash + _gap;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter old) {
    return old.color != color || old.radius != radius;
  }
}
