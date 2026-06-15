import 'package:flutter/material.dart';

import '../models/headline_entry.dart';
import '../services/settings_service.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({
    super.key,
    required this.settings,
    required this.onSelectEntry,
    required this.onDelete,
  });

  final SettingsService settings;
  final Future<void> Function(HeadlineEntry entry) onSelectEntry;
  final Future<void> Function(String id) onDelete;

  @override
  State<FavoritesScreen> createState() => FavoritesScreenState();
}

class FavoritesScreenState extends State<FavoritesScreen> {
  List<HeadlineEntry> _favorites = [];

  @override
  void initState() {
    super.initState();
    refresh();
  }

  Future<void> refresh() async {
    final favorites = await widget.settings.loadFavorites();
    if (mounted) {
      setState(() => _favorites = favorites);
    }
  }

  Future<void> _delete(String id) async {
    await widget.onDelete(id);
    await refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        foregroundColor: Colors.white,
        title: const Text('Liked'),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        children: [
          if (_favorites.isEmpty)
            const Text(
              'Liked headlines will appear here when you add them '
              'with the heart on the main screen.',
              style: TextStyle(color: Colors.white60),
            )
          else
            ..._favorites.map(
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
                  trailing: IconButton(
                    tooltip: 'Remove',
                    icon: const Icon(Icons.delete_outline, color: Colors.white54),
                    onPressed: () => _delete(entry.id),
                  ),
                  onTap: () => widget.onSelectEntry(entry),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
