part of '../view/visit_detail_page.dart';

/// Tells the person that live location sharing needs location permission set
/// to "Allow all the time", with a button to the app's permission settings.
/// Draws nothing while the permission is already "always".
///
/// WHY re-checked on resume: the person comes back from the settings screen
/// into this page, so the notice must clear itself without a restart.
class _LocationPermissionNotice extends StatefulWidget {
  const _LocationPermissionNotice();

  @override
  State<_LocationPermissionNotice> createState() =>
      _LocationPermissionNoticeState();
}

class _LocationPermissionNoticeState extends State<_LocationPermissionNotice>
    with WidgetsBindingObserver {
  LocationPermission? _permission;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _check();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _check();
  }

  Future<void> _check() async {
    try {
      final permission = await Geolocator.checkPermission();
      if (!mounted) return;
      setState(() => _permission = permission);
    } catch (_) {
      // WHY ignored: with no answer there is no notice; the check-in itself
      // still reports a permission problem.
    }
  }

  @override
  Widget build(BuildContext context) {
    final permission = _permission;
    if (permission == null || permission == LocationPermission.always) {
      return const SizedBox.shrink();
    }

    final spacing = context.dimensions.spacing;
    final color = context.color;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(spacing.s12),
      decoration: BoxDecoration(
        color: color.warningAlt,
        border: Border.all(color: color.warning),
        borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.location_off_outlined, size: 18, color: color.warning),
              Gap(spacing.s8),
              Expanded(
                child: Text(
                  context.locale.locationAlwaysAllowMessage,
                  style: context.textStyle.bodySmall.copyWith(
                    color: color.text.primary,
                  ),
                ),
              ),
            ],
          ),
          Gap(spacing.s8),
          OutlinedButton(
            onPressed: Geolocator.openAppSettings,
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: spacing.s8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  context.dimensions.radius.r6,
                ),
              ),
              side: BorderSide(color: color.warning),
            ),
            child: Text(
              context.locale.openAppSettings,
              style: TextStyle(color: color.text.primary),
            ),
          ),
        ],
      ),
    );
  }
}
