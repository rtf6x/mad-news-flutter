import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../i18n.dart';
import '../models/headline_entry.dart';
import '../services/settings_service.dart';

class SidePanelScreen extends StatefulWidget {
  const SidePanelScreen({
    super.key,
    required this.locale,
    required this.settings,
    required this.onSelectEntry,
    required this.onLocaleChanged,
  });

  final String locale;
  final SettingsService settings;
  final Future<void> Function(HeadlineEntry entry) onSelectEntry;
  final VoidCallback onLocaleChanged;

  @override
  State<SidePanelScreen> createState() => SidePanelScreenState();
}

class SidePanelScreenState extends State<SidePanelScreen> {
  List<HeadlineEntry> _history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> refresh() async {
    await _loadHistory();
  }

  Future<void> _loadHistory() async {
    final history = await widget.settings.loadHistory();
    if (mounted) {
      setState(() => _history = history);
    }
  }

  Future<void> _setAndroidLocale(String code) async {
    await widget.settings.setAndroidLocaleOverride(code);
    widget.onLocaleChanged();
  }

  Future<void> _openIosSettings() async {
    final uri = Uri.parse('app-settings:');
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(tr(widget.locale, 'couldNotOpenSettings'))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = widget.locale;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        foregroundColor: Colors.white,
        title: Text(tr(locale, 'app.title')),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        children: [
          _sectionTitle(tr(locale, 'language')),
          const SizedBox(height: 8),
          if (Platform.isAndroid) ...[
            SegmentedButton<String>(
              segments: [
                ButtonSegment(
                  value: 'ru',
                  label: Text(tr(locale, 'language.ru')),
                ),
                ButtonSegment(
                  value: 'en',
                  label: Text(tr(locale, 'language.en')),
                ),
              ],
              selected: {locale},
              onSelectionChanged: (selection) {
                _setAndroidLocale(selection.first);
              },
            ),
          ] else ...[
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                locale == 'ru'
                    ? tr(locale, 'language.ru')
                    : tr(locale, 'language.en'),
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                tr(locale, 'language.iosHint'),
                style: const TextStyle(color: Colors.white60),
              ),
              trailing: TextButton(
                onPressed: _openIosSettings,
                child: Text(tr(locale, 'openSettings')),
              ),
            ),
          ],
          const SizedBox(height: 28),
          _sectionTitle(tr(locale, 'recentHeadlines')),
          const SizedBox(height: 8),
          if (_history.isEmpty)
            Text(
              tr(locale, 'noHeadlinesYet'),
              style: const TextStyle(color: Colors.white60),
            )
          else
            ..._history.map(
              (entry) => Card(
                color: const Color(0xFF1E1E1E),
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  title: Text(
                    entry.preview,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  subtitle: Text(
                    _formatTime(entry.createdAt),
                    style: const TextStyle(color: Colors.white38, fontSize: 12),
                  ),
                  onTap: () => widget.onSelectEntry(entry),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  String _formatTime(int millis) {
    final date = DateTime.fromMillisecondsSinceEpoch(millis);
    final local = MaterialLocalizations.of(context).formatShortDate(date);
    final time = MaterialLocalizations.of(context).formatTimeOfDay(
      TimeOfDay.fromDateTime(date),
      alwaysUse24HourFormat: true,
    );
    return '$local $time';
  }
}
