import 'dart:io';

import 'package:url_launcher/url_launcher.dart';

/// Hands [lat]/[lng] to an installed maps app, falling back to the web link.
Future<void> openInMaps(double lat, double lng) async {
  final nativeUri = Platform.isIOS
      ? Uri.parse('maps://?q=$lat,$lng')
      : Uri.parse('geo:$lat,$lng?q=$lat,$lng');
  final webUri = Uri.parse(
    'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
  );

  if (await canLaunchUrl(nativeUri)) {
    await launchUrl(nativeUri, mode: LaunchMode.externalApplication);
  } else if (await canLaunchUrl(webUri)) {
    await launchUrl(webUri, mode: LaunchMode.externalApplication);
  }
}

Future<void> callNumber(String phoneNumber) async {
  final uri = Uri(scheme: 'tel', path: phoneNumber);
  if (await canLaunchUrl(uri)) await launchUrl(uri);
}
