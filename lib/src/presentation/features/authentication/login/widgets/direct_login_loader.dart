part of '../view/login_page.dart';

/// Full-screen "Signing in as ..." state: the account avatar inside a ring with
/// a brand-colored arc sweeping around it.
class _DirectLoginLoader extends StatefulWidget {
  const _DirectLoginLoader({
    required this.account,
    this.onCancel,
  });

  final SavedAccountEntity account;
  /// Null once sign-in has succeeded and there is nothing left to cancel.
  final VoidCallback? onCancel;

  @override
  State<_DirectLoginLoader> createState() => _DirectLoginLoaderState();
}

class _DirectLoginLoaderState extends State<_DirectLoginLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final dimensions = context.dimensions;
    final textStyle = context.textStyle;
    final account = widget.account;
    final ringSize = dimensions.spacing.s96;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: dimensions.padding.p24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: ringSize,
              height: ringSize,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  RotationTransition(
                    turns: _controller,
                    child: CustomPaint(
                      size: Size.square(ringSize),
                      painter: _RingPainter(
                        track: colors.border,
                        arc: colors.primary,
                      ),
                    ),
                  ),
                  AccountAvatar(
                    name: account.name,
                    uid: account.uid,
                    thumbnail: account.thumbnail,
                    size: dimensions.spacing.s80,
                  ),
                ],
              ),
            ),
            SizedBox(height: dimensions.spacing.s32),
            Text(
              context.locale.signingInAs(account.name),
              textAlign: TextAlign.center,
              style: textStyle.headlineMedium.copyWith(
                color: colors.text.primary,
              ),
            ),
            SizedBox(height: dimensions.spacing.s4),
            Text(
              account.uid,
              style: textStyle.bodySmall.copyWith(color: colors.text.secondary),
            ),
            SizedBox(height: dimensions.spacing.s32),
            // WHY kept in the layout: the text must not jump when Cancel goes.
            Visibility(
              visible: widget.onCancel != null,
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              child: TextButton(
                onPressed: widget.onCancel,
                child: Text(context.locale.cancel),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  const _RingPainter({required this.track, required this.arc});

  final Color track;
  final Color arc;

  static const _stroke = 4.0;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final inset = rect.deflate(_stroke / 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = _stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(inset.center, inset.width / 2, paint..color = track);
    canvas.drawArc(inset, -math.pi / 2, math.pi / 2, false, paint..color = arc);
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.track != track || old.arc != arc;
}
