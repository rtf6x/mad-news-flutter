import 'package:flutter/material.dart';

import 'src/generator.dart';
import 'src/models/headline_entry.dart';
import 'src/screens/favorites_screen.dart';
import 'src/screens/home_screen.dart';
import 'src/screens/side_panel_screen.dart';
import 'src/services/headline_factory.dart';
import 'src/services/settings_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GeneratorData.load();
  final settings = await SettingsService.create();
  runApp(MadNewsApp(settings: settings));
}

class MadNewsApp extends StatefulWidget {
  const MadNewsApp({super.key, required this.settings});

  final SettingsService settings;

  @override
  State<MadNewsApp> createState() => _MadNewsAppState();
}

class _MadNewsAppState extends State<MadNewsApp> with WidgetsBindingObserver {
  static const _homePageIndex = 1;

  final PageController _pageController =
      PageController(initialPage: _homePageIndex);
  final GlobalKey<FavoritesScreenState> _favoritesKey =
      GlobalKey<FavoritesScreenState>();
  final GlobalKey<SidePanelScreenState> _sidePanelKey =
      GlobalKey<SidePanelScreenState>();

  HeadlineEntry? _activeEntry;
  bool _isLiked = false;
  bool _blockGenerate = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _generateInitialEntry();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pageController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _sidePanelKey.currentState?.refresh();
      _favoritesKey.currentState?.refresh();
    }
  }

  Future<void> _generateInitialEntry() async {
    final entry = await HeadlineFactory.createRandom(widget.settings);
    await widget.settings.addToHistory(entry);
    final liked = await widget.settings.isFavorite(entry.id);
    if (!mounted) {
      return;
    }
    setState(() {
      _activeEntry = entry;
      _isLiked = liked;
    });
  }

  Future<void> _generateNew() async {
    if (_blockGenerate) {
      return;
    }
    final entry = await HeadlineFactory.createRandom(widget.settings);
    await widget.settings.addToHistory(entry);
    final liked = await widget.settings.isFavorite(entry.id);
    if (!mounted) {
      return;
    }
    setState(() {
      _activeEntry = entry;
      _isLiked = liked;
    });
  }

  Future<void> _showEntry(HeadlineEntry entry) async {
    final liked = await widget.settings.isFavorite(entry.id);
    if (!mounted) {
      return;
    }
    setState(() {
      _activeEntry = entry;
      _isLiked = liked;
      _blockGenerate = true;
    });
    _pageController.jumpToPage(_homePageIndex);
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      setState(() => _blockGenerate = false);
    }
  }

  Future<void> _toggleLike() async {
    final entry = _activeEntry;
    if (entry == null) {
      return;
    }
    if (_isLiked) {
      await widget.settings.removeFavorite(entry.id);
    } else {
      await widget.settings.addFavorite(entry);
    }
    if (!mounted) {
      return;
    }
    setState(() => _isLiked = !_isLiked);
    _favoritesKey.currentState?.refresh();
  }

  Future<void> _onLocaleChanged() async {
    await _generateNew();
  }

  Future<void> _onFavoriteDeleted(String id) async {
    await widget.settings.removeFavorite(id);
    if (_activeEntry?.id == id && mounted) {
      setState(() => _isLiked = false);
    }
    await _favoritesKey.currentState?.refresh();
  }

  void _openFavorites() {
    _favoritesKey.currentState?.refresh();
    _pageController.animateToPage(
      0,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOut,
    );
  }

  void _openSidePanel() {
    _sidePanelKey.currentState?.refresh();
    _pageController.animateToPage(
      2,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final entry = _activeEntry;

    return MaterialApp(
      title: 'MadNews',
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: entry == null
          ? const Scaffold(
              backgroundColor: Colors.black,
              body: Center(child: CircularProgressIndicator()),
            )
          : PageView(
              controller: _pageController,
              physics: const BouncingScrollPhysics(),
              children: [
                FavoritesScreen(
                  key: _favoritesKey,
                  settings: widget.settings,
                  onSelectEntry: _showEntry,
                  onDelete: _onFavoriteDeleted,
                ),
                HomeScreen(
                  entry: entry,
                  isLiked: _isLiked,
                  blockGenerate: _blockGenerate,
                  onGenerateNew: _generateNew,
                  onToggleLike: _toggleLike,
                  onOpenFavorites: _openFavorites,
                  onOpenSidePanel: _openSidePanel,
                ),
                SidePanelScreen(
                  key: _sidePanelKey,
                  settings: widget.settings,
                  onSelectEntry: _showEntry,
                  onLocaleChanged: _onLocaleChanged,
                ),
              ],
            ),
    );
  }
}
