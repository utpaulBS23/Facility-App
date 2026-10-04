import 'package:facility_management_app/src/core/utils/localized_text.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('localizedText', () {
    test('bn language uses the Bangla value when present', () {
      expect(localizedText('bn', 'Hand Soap', 'হ্যান্ড সোপ'), 'হ্যান্ড সোপ');
    });

    test('bn language falls back to base when Bangla is null or blank', () {
      expect(localizedText('bn', 'Hand Soap', null), 'Hand Soap');
      expect(localizedText('bn', 'Hand Soap', '  '), 'Hand Soap');
    });

    test('en language ignores the Bangla value', () {
      expect(localizedText('en', 'Hand Soap', 'হ্যান্ড সোপ'), 'Hand Soap');
    });
  });
}
