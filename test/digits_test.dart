import 'package:facility_management_app/src/core/utils/digits.dart';
import 'package:facility_management_app/src/presentation/core/utils/number_formatter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Digits', () {
    test('toLatin maps Bangla and Arabic-Indic digits', () {
      expect(Digits.toLatin('০১২৩৪৫৬৭৮৯'), '0123456789');
      expect(Digits.toLatin('٠١٢٣'), '0123');
      expect(Digits.toLatin('+৮৮০১৭'), '+88017');
    });

    test('toBangla keeps symbols and leading zeros', () {
      expect(Digits.toBangla('+8801712-345 678'), '+৮৮০১৭১২-৩৪৫ ৬৭৮');
    });

    test('localize only changes Bangla', () {
      expect(Digits.localize('017', 'bn'), '০১৭');
      expect(Digits.localize('017', 'en'), '017');
    });

    test('parse handles Bangla digits and commas', () {
      expect(Digits.parseDouble('৫০০.৫'), 500.5);
      expect(Digits.parseInt('১,২৩৪'), 1234);
      expect(Digits.parseNum('abc'), isNull);
      expect(Digits.parseNum(null), isNull);
    });
  });

  group('AppNumbers', () {
    const en = AppNumbers('en');
    const bn = AppNumbers('bn');

    test('integer', () {
      expect(en.integer(1234567), '1,234,567');
      expect(bn.integer(1234567), '১২,৩৪,৫৬৭');
    });

    test('decimal keeps fixed fraction digits', () {
      expect(en.decimal(1234.5, 2), '1,234.50');
      expect(bn.decimal(1234.5, 2), '১,২৩৪.৫০');
    });

    test('currency drops zero decimals, keeps up to two', () {
      expect(en.currency(500), '৳500');
      expect(bn.currency(500), '৳৫০০');
      expect(en.currency(12.345), '৳12.35');
    });

    test('percent', () {
      expect(en.percent(87.46, fractionDigits: 1), '87.5%');
      expect(bn.percent(87.46, fractionDigits: 1), '৮৭.৫%');
    });

    test('phone maps every digit', () {
      expect(bn.phone('+8801712345678'), '+৮৮০১৭১২৩৪৫৬৭৮');
      expect(en.phone('+8801712345678'), '+8801712345678');
      expect(bn.phone(null), '');
    });

    test('non-numeric input is returned as-is', () {
      expect(bn.integer('n/a'), 'n/a');
      expect(bn.integer(null), '');
    });
  });
}
