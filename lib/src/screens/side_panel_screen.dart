import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/headline_entry.dart';
import '../services/settings_service.dart';

class SidePanelScreen extends StatefulWidget {
  const SidePanelScreen({
    super.key,
    required this.settings,
    required this.onSelectEntry,
    required this.onLocaleChanged,
  });

  final SettingsService settings;
  final ValueChanged<HeadlineEntry> onSelectEntry;
  final VoidCallback onLocaleChanged;

  @override
  State<SidePanelScreen> createState() => SidePanelScreenState();
}

class SidePanelScreenState extends State<SidePanelScreen> {
  List<HeadlineEntry> _history = [];
  late String _displayLocale;

  @override
  void initState() {
    super.initState();
    _displayLocale = widget.settings.currentDisplayLocale();
    _loadHistory();
  }

  Future<void> refresh() async {
    _displayLocale = widget.settings.currentDisplayLocale();
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
    setState(() => _displayLocale = code);
    widget.onLocaleChanged();
  }

  Future<void> _openIosSettings() async {
    final uri = Uri.parse('app-settings:');
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open Settings')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        foregroundColor: Colors.white,
        title: const Text('MadNews'),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        children: [
          _sectionTitle('Language'),
          const SizedBox(height: 8),
          if (Platform.isAndroid) ...[
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'ru', label: Text('Русский')),
                ButtonSegment(value: 'en', label: Text('English')),
              ],
              selected: {_displayLocale},
              onSelectionChanged: (selection) {
                _setAndroidLocale(selection.first);
              },
            ),
          ] else ...[
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                _displayLocale == 'ru' ? 'Русский' : 'English',
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: const Text(
                'Change in iOS Settings → MadNews → Language',
                style: TextStyle(color: Colors.white60),
              ),
              trailing: TextButton(
                onPressed: _openIosSettings,
                child: const Text('Open Settings'),
              ),
            ),
          ],
          const SizedBox(height: 28),
          _sectionTitle('Recent headlines'),
          const SizedBox(height: 8),
          if (_history.isEmpty)
            const Text(
              'No headlines yet. Tap the main screen to generate one.',
              style: TextStyle(color: Colors.white60),
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
