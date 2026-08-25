import 'package:flutter/widgets.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../core/widgets/placeholder_page.dart';

/// WHY one screen for three permissions: the matrix folds
/// `supply_request.view`, `delivery_tracking.view`, and
/// `delivery_complaint.view` into a single Operation Manager screen. Each
/// section should gate itself with [PermissionGate] once built out — this
/// placeholder covers routing only.
class SupplyRequestPage extends StatelessWidget {
  const SupplyRequestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PlaceholderPage(title: context.locale.supplyRequest);
  }
}
