import 'package:flutter/widgets.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../core/widgets/placeholder_page.dart';

/// WHY this exists as a bare placeholder: `iot_gateway.configure` is flagged
/// TBD in the source permission matrix — it may fold into an existing
/// `device.configure` resource instead of being its own thing. Don't build
/// real functionality behind this until backend confirms the resource.
class GatewayManagementPage extends StatelessWidget {
  const GatewayManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PlaceholderPage(title: context.locale.gatewayManagement);
  }
}
