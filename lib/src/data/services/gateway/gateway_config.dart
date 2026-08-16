/// Gateway deployment config.
///
/// WHY hardcoded: each facility's relay controller is a LAN device with no
/// central registry yet — same stopgap as [Endpoints.base] before a real
/// per-facility device directory exists. [relayForFacility] falls back to
/// relay 1 so an unmapped facility still gets a door instead of a hard error.
abstract final class GatewayConfig {
  static const String baseUrl = 'http://192.168.1.100:5454';

  static const Map<String, int> _facilityRelayMap = {};

  static int relayForFacility(String facilityId) =>
      _facilityRelayMap[facilityId] ?? 1;
}
