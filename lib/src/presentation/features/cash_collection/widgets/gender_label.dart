import 'package:flutter/widgets.dart';

import '../../../../core/extensions/app_localization.dart';

/// The localized Male / Female label of a service's `gender` wire value; any
/// other value is shown as the server sent it.
String genderLabel(BuildContext context, String gender) => switch (gender) {
  'male' => context.locale.male,
  'female' => context.locale.female,
  final other => other,
};
