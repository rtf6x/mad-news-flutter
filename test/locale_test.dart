import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:mad_news_flutter/src/i18n.dart';
import 'package:mad_news_flutter/src/services/settings_service.dart';

void main() {
  test('localeFromSystem maps Russian family to ru', () {
    expect(
      SettingsService.localeFromSystem(locale: const Locale('ru')),
      'ru',
    );
    expect(
      SettingsService.localeFromSystem(locale: const Locale('uk')),
      'ru',
    );
    expect(
      SettingsService.localeFromSystem(locale: const Locale('en', 'US')),
      'en',
    );
  });

  test('tr returns Russian UI strings', () {
    expect(tr('ru', 'liked'), 'Избранное');
    expect(tr('ru', 'language'), 'Язык');
    expect(tr('en', 'liked'), 'Liked');
  });
}
