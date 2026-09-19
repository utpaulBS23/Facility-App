import 'dart:io';

import 'package:url_launcher/url_launcher.dart';

import '../../../../domain/entities/toilet_location/toilet_entity.dart';

extension ToiletDirectionLauncher on ToiletEntity {
  Future<void> openDirection() async {
    final fallbackUri = mapsLink.isNotEmpty
        ? Uri.parse(mapsLink)
        : Uri.parse(
            'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
          );

    // WHY: the https maps link routes through a browser/Play-services
    // resolver dialog before landing in Maps. geo:/maps: URIs hand the
    // intent straight to an installed maps app, skipping that detour.
    final nativeUri = Platform.isIOS
        ? Uri.parse('maps://?q=$lat,$lng')
        : Uri.parse('geo:$lat,$lng?q=$lat,$lng');

    if (await canLaunchUrl(nativeUri)) {
      await launchUrl(nativeUri, mode: LaunchMode.externalApplication);
      return;
    }

    if (await canLaunchUrl(fallbackUri)) {
      await launchUrl(fallbackUri, mode: LaunchMode.externalApplication);
    }
  }
}
