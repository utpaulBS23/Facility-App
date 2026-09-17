import 'package:flutter/material.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../../domain/entities/toilet_location/toilet_status.dart';
import '../../../core/theme/theme.dart';

extension ToiletStatusLocalization on ToiletStatus {
  String localizedName(BuildContext context) {
    return switch (this) {
      ToiletStatus.active => context.locale.open,
      ToiletStatus.inactive => context.locale.close,
      ToiletStatus.maintenance => context.locale.underConstruction,
      ToiletStatus.unknown => context.locale.notAvailable,
    };
  }

  Color statusColor(BuildContext context) {
    return switch (this) {
      ToiletStatus.active => context.color.success,
      ToiletStatus.inactive => context.color.text.secondary,
      ToiletStatus.maintenance => context.color.warning,
      ToiletStatus.unknown => context.color.text.secondary,
    };
  }
}
