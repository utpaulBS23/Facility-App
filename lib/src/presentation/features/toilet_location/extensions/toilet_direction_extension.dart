import 'package:url_launcher/url_launcher.dart';

import '../../../../domain/entities/toilet_location/toilet_entity.dart';

extension ToiletDirectionLauncher on ToiletEntity {
  Future<void> openDirection() async {
    final uri = mapsLink.isNotEmpty
        ? Uri.parse(mapsLink)
        : Uri.parse(
            'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
          );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
