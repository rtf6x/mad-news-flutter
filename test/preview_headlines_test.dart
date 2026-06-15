import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mad_news_flutter/src/generator.dart';

/// Print random headlines to the terminal.
///
///   flutter test test/preview_headlines_test.dart --plain-name preview
///   LOCALE=ru COUNT=20 flutter test test/preview_headlines_test.dart --plain-name preview
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('preview', () async {
    await GeneratorData.load();

    final locale = Platform.environment['LOCALE'] ?? 'en';
    final count = int.tryParse(Platform.environment['COUNT'] ?? '') ?? 10;

    // ignore: avoid_print
    print('Locale: $locale, count: $count\n');

    for (var i = 0; i < count; i++) {
      final headline = MadNews(localeOverride: locale);
      // ignore: avoid_print
      print('--- ${i + 1} ---');
      // ignore: avoid_print
      print(headline.getPerson());
      // ignore: avoid_print
      print(headline.getAction());
      // ignore: avoid_print
      print(headline.getConclusion());
      // ignore: avoid_print
      print('');
    }
  });
}
