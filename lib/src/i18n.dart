const supportedLocales = ['en', 'ru'];

String resolveLocale(String? code) {
  final lang = (code ?? 'en').toLowerCase().split('_').first;
  return supportedLocales.contains(lang) ? lang : 'en';
}

const _strings = <String, Map<String, String>>{
  'en': {
    'app.title': 'MadNews',
    'language': 'Language',
    'language.ru': 'Русский',
    'language.en': 'English',
    'language.iosHint': 'Change in iOS Settings → MadNews → Language',
    'openSettings': 'Open Settings',
    'couldNotOpenSettings': 'Could not open Settings',
    'recentHeadlines': 'Recent headlines',
    'noHeadlinesYet':
        'No headlines yet. Tap the main screen to generate one.',
    'liked': 'Liked',
    'likedEmpty':
        'Liked headlines will appear here when you add them '
        'with the heart on the main screen.',
    'remove': 'Remove',
    'shareImage': 'Share image',
    'saveToPhotos': 'Save to Photos',
    'savedToPhotos': 'Saved to Photos',
    'tooltip.likedHeadlines': 'Liked headlines',
    'tooltip.unlike': 'Unlike',
    'tooltip.like': 'Like',
    'tooltip.share': 'Share',
    'tooltip.historySettings': 'History & settings',
  },
  'ru': {
    'app.title': 'MadNews',
    'language': 'Язык',
    'language.ru': 'Русский',
    'language.en': 'English',
    'language.iosHint': 'Сменить в Настройки iOS → MadNews → Язык',
    'openSettings': 'Открыть настройки',
    'couldNotOpenSettings': 'Не удалось открыть настройки',
    'recentHeadlines': 'Недавние заголовки',
    'noHeadlinesYet':
        'Заголовков пока нет. Нажмите на главный экран, чтобы создать.',
    'liked': 'Избранное',
    'likedEmpty':
        'Понравившиеся заголовки появятся здесь, когда вы отметите их '
        'сердечком на главном экране.',
    'remove': 'Удалить',
    'shareImage': 'Поделиться изображением',
    'saveToPhotos': 'Сохранить в Фото',
    'savedToPhotos': 'Сохранено в Фото',
    'tooltip.likedHeadlines': 'Избранные заголовки',
    'tooltip.unlike': 'Убрать из избранного',
    'tooltip.like': 'В избранное',
    'tooltip.share': 'Поделиться',
    'tooltip.historySettings': 'История и настройки',
  },
};

String tr(String locale, String key) =>
    _strings[resolveLocale(locale)]?[key] ?? _strings['en']![key] ?? key;
