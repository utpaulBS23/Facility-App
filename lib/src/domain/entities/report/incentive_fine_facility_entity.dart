import '../../../core/utils/localized_text.dart';

class IncentiveFineFacilityEntity {
  const IncentiveFineFacilityEntity({
    required this.facilityName,
    this.facilityNameBn = '',
    required this.achievementRate,
    required this.target,
    required this.income,
  });

  final String facilityName;
  final String facilityNameBn;
  final double achievementRate;
  final double target;
  final double income;

  String localizedFacilityName(String languageCode) =>
      localizedText(languageCode, facilityName, facilityNameBn);
}
