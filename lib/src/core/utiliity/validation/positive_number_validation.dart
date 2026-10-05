import 'package:flutter/material.dart';

import '../../extensions/app_localization.dart';
import 'validation.dart';
import '../../utils/digits.dart';

/// Requires the field to parse as a number greater than zero.
class PositiveNumberValidation extends Validation<String> {
  @override
  String? validate(BuildContext context, String? value) {
    final parsed = Digits.parseDouble(value?.trim());
    if (parsed == null || parsed <= 0) {
      return context.locale.isRequired;
    }
    return null;
  }
}
