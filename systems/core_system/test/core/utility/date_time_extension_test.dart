import 'package:core_system/core/utility/extensions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  // The running app gets this for free from GlobalMaterialLocalizations;
  // a bare unit test has to ask for it.
  setUpAll(() async => await initializeDateFormatting());

  group('DateTimeExtension.format', () {
    // No navigator is mounted here, which is exactly the case that used to
    // throw a null-check error before the locale lookup was made safe.
    final DateTime date = DateTime(2027, 12, 5);

    test('formats without a mounted navigator, falling back to the app '
        'language', () {
      expect(date.format('dd/MM/yyyy'), '05/12/2027');
    });

    test('formats Arabic with western digits', () {
      expect(date.format('d MMM yyyy', cutomlocale: 'ar'), '5 ديسمبر 2027');
    });

    test('honours an explicit locale', () {
      expect(date.format('d MMM yyyy', cutomlocale: 'en'), '5 Dec 2027');
    });

    test(
      'returns an empty string instead of throwing on unknown locale data',
      () {
        expect(date.format('dd/MM/yyyy', cutomlocale: 'not-a-locale'), '');
      },
    );
  });
}
