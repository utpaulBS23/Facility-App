import 'app_permission.dart';

class MenuConfigItemEntity {
  const MenuConfigItemEntity({
    required this.itemKey,
    required this.permissions,
    required this.isGated,
    this.label,
    this.labelBn = '',
    this.sublabel,
    this.sublabelBn = '',
  });

  final String itemKey;
  final String? label;
  final String labelBn;
  final String? sublabel;
  final String sublabelBn;
  final Set<UserPermission> permissions;

  /// WHY separate from [permissions]: the server sends an empty key list for
  /// "no gate", but unknown keys are dropped from [permissions]. An item gated
  /// only on keys this build doesn't know must stay hidden, not become open.
  final bool isGated;

  bool isGrantedTo(Set<UserPermission> held) =>
      !isGated || permissions.any(held.contains);

  /// Server label for [languageCode]: Bangla when asked and sent, else
  /// English. Empty when the server sent none — the item still shows, unnamed.
  String localizedLabel(String languageCode) =>
      _pick(languageCode, label, labelBn) ?? '';

  String? localizedSublabel(String languageCode) =>
      _pick(languageCode, sublabel, sublabelBn);

  static String? _pick(String languageCode, String? en, String? bn) {
    final value = languageCode == 'bn' ? (bn ?? en) : en;

    return (value == null || value.isEmpty) ? null : value;
  }
}

class MenuConfigurationEntity {
  const MenuConfigurationEntity({
    required this.version,
    required this.tabs,
    required this.drawer,
  });

  final String version;
  final List<MenuConfigItemEntity> tabs;
  final List<MenuConfigItemEntity> drawer;
}
