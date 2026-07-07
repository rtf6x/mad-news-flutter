# Agent instructions — mad-news-flutter

Инструкции для AI-агентов и разработчиков, работающих с этим репозиторием.

## Принципы разработки

**KISS / YAGNI.** Решай только текущую задачу. Минимальный diff.

**Точность.** Генератор заголовков — порт веб-логики из `rootfox.cc/games/mad-news/`.

**Запрет на раздувание scope** без запроса.

---

## Проект

| | |
|--|--|
| **Что** | MadNews (Flutter) |
| **Bundle ID** | `cc.rootfox.madnews` |
| **Team ID (Apple)** | `Q4KD7AC52U` |
| **Веб-оригинал** | https://rootfox.cc/games/mad-news/ |
| **Стек** | Flutter 3.7+, Dart, `shared_preferences`, `share_plus`, `url_launcher` |
| **Скриншоты (`<game>`)** | `mad-news` |

---

## Структура кода

| Путь | Назначение |
|------|------------|
| `lib/main.dart` | PageView: избранное, главная, боковая панель |
| `lib/src/screens/home_screen.dart` | Заголовок, лайк, шаринг |
| `lib/src/screens/favorites_screen.dart` | Избранные заголовки |
| `lib/src/screens/side_panel_screen.dart` | История, язык |
| `lib/src/services/settings_service.dart` | История, избранное, locale |
| `integration_test/screenshots_test.dart` | Скриншоты для сторов |

---

## Проверки и скриншоты

После **любого изменения логики**:

```bash
flutter test
flutter analyze
```

Интеграционные тесты — на симуляторе **iPhone 17** (`D6ECC10E-B0B1-4E06-B718-4DE6F1BAAB01`):

```bash
flutter test integration_test/ -d D6ECC10E-B0B1-4E06-B718-4DE6F1BAAB01
```

После **изменения экранов** (верстка, навигация, тексты, настройки) — скриншоты:

```bash
~/Projects/rtf6x/screenshot_runner/capture_all.sh
```

Подробности: [`../screenshot_runner/README.md`](../screenshot_runner/README.md).

**Экраны этого проекта:** `home`, `favorites`, `settings` · **языки:** `en`, `ru`.

Путь: `~/Downloads/screens/mad-news/[resolution]/[locale]-[screen].png`  
Симуляторы: iPhone 17, iPad Pro 11-inch (M5).  
Разрешения: `1242x2688`, `2688x1242`, `1668x2420`, `2420x1668`.

---

## Навигация

- **Свайп / ◀ ▶** — избранное ↔ главная ↔ история и настройки
- **Тап по экрану** — новый заголовок
