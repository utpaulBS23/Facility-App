import 'package:flutter/widgets.dart';

import '../../../../../core/extensions/app_localization.dart';
import '../../../../../domain/entities/master_data_entity.dart';
import '../../../../../domain/entities/toilet_location/facility_monthly_report_entity.dart';

/// `water_bill` becomes `Water bill`: the server's key made readable. Only
/// used when the server sent no label of its own.
String prettyKey(String key) {
  final text = key.replaceAll('_', ' ').trim();

  return text.isEmpty ? text : text[0].toUpperCase() + text.substring(1);
}

/// The name of an income line: the server's own label when it sent one
/// (extra-income types come with labels in master data), else the name or key
/// the record carried.
String reportIncomeLabel(
  BuildContext context,
  ReportIncomeLine line, {
  required List<MasterDataItemEntity> incomeTypes,
  required String languageCode,
}) {
  switch (line.kind) {
    case ReportIncomeKind.service:
    case ReportIncomeKind.product:
      return line.label;
    case ReportIncomeKind.extra:
      for (final type in incomeTypes) {
        if (type.value == line.label) return type.localizedLabel(languageCode);
      }

      return prettyKey(line.label);
    case ReportIncomeKind.app:
      return prettyKey(line.label);
    case ReportIncomeKind.cashProduct:
      return context.locale.productSell;
    case ReportIncomeKind.rentingOthers:
      // TODO: English only until the next localisation pass.
      return 'Renting & others';
  }
}
