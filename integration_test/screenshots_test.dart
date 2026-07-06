import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mad_news_flutter/main.dart';
import 'package:mad_news_flutter/src/generator.dart';
import 'package:mad_news_flutter/src/services/settings_service.dart';
import 'package:screenshot_runner/screenshot_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('store screenshots', (tester) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('android_locale', screenshotLocale);

    WidgetsFlutterBinding.ensureInitialized();
    await GeneratorData.load();
    final settings = await SettingsService.create();
    runApp(MadNewsApp(settings: settings));

    await tester.pumpAndSettle(const Duration(seconds: 10));
    await applyScreenshotLayout(tester, binding);
    await waitFor(tester, find.byType(PageView));

    if (screenshotIsTablet) {
      await saveScreenshot(binding, 'home');

      await tester.tap(find.byIcon(Icons.chevron_right).first);
      await tester.pumpAndSettle();
      await waitFor(tester, find.text('Language'));
      await saveScreenshot(binding, 'settings');

      await tester.fling(find.byType(PageView), const Offset(1200, 0), 5000);
      await tester.pumpAndSettle();
      await tester.fling(find.byType(PageView), const Offset(1200, 0), 5000);
      await tester.pumpAndSettle();
      await waitFor(tester, find.text('Liked'));
      await saveScreenshot(binding, 'favorites');
      return;
    }

    await saveScreenshot(binding, 'home');

    await tester.tap(find.byIcon(Icons.chevron_left).first);
    await tester.pumpAndSettle();
    await saveScreenshot(binding, 'favorites');

    await tester.drag(find.byType(PageView), const Offset(-500, 0));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.chevron_right).first);
    await tester.pumpAndSettle();
    await waitFor(tester, find.text('Language'));
    await saveScreenshot(binding, 'settings');
  });
}
