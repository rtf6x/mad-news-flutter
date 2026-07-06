import 'dart:convert';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/headline_entry.dart';

class SettingsService {
  SettingsService(this._prefs);

  static const _historyKey = 'headline_history';
  static const _favoritesKey = 'headline_favorites';
  static const _androidLocaleKey = 'android_locale';
  static const maxHistoryItems = 5;

  final SharedPreferences _prefs;

  static Future<SettingsService> create() async {
    return SettingsService(await SharedPreferences.getInstance());
  }

  Future<List<HeadlineEntry>> loadHistory() async {
    final raw = _prefs.getString(_historyKey);
    if (raw == null || raw.isEmpty) {
      return [];
    }
    final list = jsonDecode(raw) as List<dynamic>;
    final history = list
        .map((item) => HeadlineEntry.fromJson(item as Map<String, dynamic>))
        .toList();
    if (history.length > maxHistoryItems) {
      final trimmed = history.sublist(0, maxHistoryItems);
      await _saveHistory(trimmed);
      return trimmed;
    }
    return history;
  }

  Future<void> addToHistory(HeadlineEntry entry) async {
    final history = await loadHistory();
    history.insert(0, entry);
    if (history.length > maxHistoryItems) {
      history.removeRange(maxHistoryItems, history.length);
    }
    await _saveHistory(history);
  }

  Future<void> _saveHistory(List<HeadlineEntry> history) async {
    final encoded = jsonEncode(history.map((e) => e.toJson()).toList());
    await _prefs.setString(_historyKey, encoded);
  }

  Future<List<HeadlineEntry>> loadFavorites() async {
    final raw = _prefs.getString(_favoritesKey);
    if (raw == null || raw.isEmpty) {
      return [];
    }
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((item) => HeadlineEntry.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<bool> isFavorite(String id) async {
    final favorites = await loadFavorites();
    return favorites.any((entry) => entry.id == id);
  }

  Future<void> addFavorite(HeadlineEntry entry) async {
    final favorites = await loadFavorites();
    if (favorites.any((item) => item.id == entry.id)) {
      return;
    }
    favorites.insert(0, entry);
    await _saveFavorites(favorites);
  }

  Future<void> removeFavorite(String id) async {
    final favorites = await loadFavorites();
    favorites.removeWhere((entry) => entry.id == id);
    await _saveFavorites(favorites);
  }

  Future<void> _saveFavorites(List<HeadlineEntry> favorites) async {
    final encoded = jsonEncode(favorites.map((e) => e.toJson()).toList());
    await _prefs.setString(_favoritesKey, encoded);
  }

  String? getAndroidLocaleOverride() {
    return _prefs.getString(_androidLocaleKey);
  }

  Future<void> setAndroidLocaleOverride(String localeCode) async {
    await _prefs.setString(_androidLocaleKey, localeCode);
  }

  Future<String> resolveGeneratorLocale() async {
    final override = getAndroidLocaleOverride();
    if (override != null) {
      return override;
    }
    return _localeFromSystem();
  }

  String currentDisplayLocale() {
    final override = getAndroidLocaleOverride();
    if (override != null) {
      return override;
    }
    return _localeFromSystem();
  }

  static String _localeFromSystem() {
    final code = Platform.localeName.substring(0, 2).toLowerCase();
    if (code == 'ru' || code == 'be' || code == 'uk') {
      return 'ru';
    }
    return 'en';
  }
}
