import 'package:flutter/material.dart';

import 'src/generator.dart';
import 'src/screens/favorites_screen.dart';
import 'src/screens/home_screen.dart';
import 'src/screens/side_panel_screen.dart';
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

  final PageController _pageController = PageController(initialPage: _homePageIndex);
  final GlobalKey<HomeScreenState> _homeKey = GlobalKey<HomeScreenState>();
  final GlobalKey<FavoritesScreenState> _favoritesKey =
      GlobalKey<FavoritesScreenState>();
  final GlobalKey<SidePanelScreenState> _sidePanelKey =
      GlobalKey<SidePanelScreenState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
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
      _homeKey.currentState?.reloadLocale();
    }
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

  void _openHome() {
    _pageController.animateToPage(
      _homePageIndex,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOut,
    );
  }

  void _onFavoritesChanged() {
    _favoritesKey.currentState?.refresh();
  }

  Future<void> _onFavoriteDeleted(String id) async {
    await widget.settings.removeFavorite(id);
    _homeKey.currentState?.onFavoriteRemovedExternally(id);
    await _favoritesKey.currentState?.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MadNews',
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: PageView(
        controller: _pageController,
        physics: const BouncingScrollPhysics(),
        children: [
          FavoritesScreen(
            key: _favoritesKey,
            settings: widget.settings,
            onSelectEntry: (entry) {
              _homeKey.currentState?.showEntry(entry);
              _openHome();
            },
            onDelete: _onFavoriteDeleted,
          ),
          HomeScreen(
            key: _homeKey,
            settings: widget.settings,
            onOpenFavorites: _openFavorites,
            onOpenSidePanel: _openSidePanel,
            onFavoritesChanged: _onFavoritesChanged,
          ),
          SidePanelScreen(
            key: _sidePanelKey,
            settings: widget.settings,
            onSelectEntry: (entry) {
              _homeKey.currentState?.showEntry(entry);
              _openHome();
            },
            onLocaleChanged: () {
              _homeKey.currentState?.reloadLocale();
            },
          ),
        ],
      ),
    );
  }
}
