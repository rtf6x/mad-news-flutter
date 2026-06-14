import '../generator.dart';
import '../models/headline_entry.dart';
import 'settings_service.dart';

const headlineAssets = [
  'assets/bg.jpg',
  'assets/bg2.jpg',
  'assets/bg3.jpg',
  'assets/bg4.jpg',
  'assets/bg5.jpg',
  'assets/bg6.jpg',
];

class HeadlineFactory {
  static Future<HeadlineEntry> createRandom(SettingsService settings) async {
    final locale = await settings.resolveGeneratorLocale();
    final madness = MadNews(localeOverride: locale);
    return HeadlineEntry.create(
      person: madness.getPerson().trim(),
      action: madness.getAction().trim(),
      conclusion: madness.getConclusion().trim(),
      asset: headlineAssets[
          DateTime.now().millisecondsSinceEpoch % headlineAssets.length],
    );
  }
}
