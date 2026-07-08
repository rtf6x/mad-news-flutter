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

---

## Структура кода

| Путь | Назначение |
|------|------------|
| `lib/main.dart` | PageView: избранное, главная, боковая панель |
| `lib/src/screens/home_screen.dart` | Заголовок, лайк, шаринг |
| `lib/src/screens/favorites_screen.dart` | Избранные заголовки |
| `lib/src/screens/side_panel_screen.dart` | История, язык |
| `lib/src/services/settings_service.dart` | История, избранное, locale |

---

## После каждого изменения

После **любого** завершённого изменения — **проактивно**, без отдельной просьбы пользователя:

1. Проверки по типу изменения (см. раздел «Проверки» ниже).
2. **Коммит** — если есть незакоммиченные изменения (сообщение на английском).
3. **Пуш** — `git push` в текущую ветку.
4. **Перезапуск** на симуляторах **iPhone 17** и **iPad Pro 11-inch (M5)** (оба):
   ```bash
   pkill -f "flutter_tools.snapshot run" 2>/dev/null; sleep 1
   flutter run -d D6ECC10E-B0B1-4E06-B718-4DE6F1BAAB01 &
   flutter run -d 66DA3A65-0157-47FF-BCE1-4045575DF829 &
   ```

   | Симулятор | Device ID |
   |-----------|-----------|
   | iPhone 17 | `D6ECC10E-B0B1-4E06-B718-4DE6F1BAAB01` |
   | iPad Pro 11-inch (M5) | `66DA3A65-0157-47FF-BCE1-4045575DF829` |

Не коммитить и не пушить только если пользователь явно попросил или нечего коммитить.

---

## Проверки

После **любого изменения логики**:

```bash
flutter test
flutter analyze
```


---

## Навигация

- **Свайп / ◀ ▶** — избранное ↔ главная ↔ история и настройки
- **Тап по экрану** — новый заголовок
