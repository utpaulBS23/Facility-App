import '../../core/utils/localized_text.dart';

class ShiftTemplateEntity {
  const ShiftTemplateEntity({
    required this.id,
    required this.name,
    this.nameBn,
    required this.startTime,
    required this.endTime,
    this.durationHours,
    this.isActive = true,
    this.notes,
  });

  final int id;
  final String name;
  final String? nameBn;
  final String startTime;
  final String endTime;
  final String? durationHours;
  final bool isActive;
  final String? notes;

  String localizedName(String languageCode) =>
      localizedText(languageCode, name, nameBn);
}
