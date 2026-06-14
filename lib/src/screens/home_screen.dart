import 'package:flutter/material.dart';

import '../generator.dart';
import '../models/headline_entry.dart';
import '../services/screenshot_service.dart';
import '../services/settings_service.dart';

const headlineAssets = [
  'assets/bg.jpg',
  'assets/bg2.jpg',
  'assets/bg3.jpg',
  'assets/bg4.jpg',
  'assets/bg5.jpg',
  'assets/bg6.jpg',
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.settings,
    required this.onOpenFavorites,
    required this.onOpenSidePanel,
    required this.onFavoritesChanged,
  });

  final SettingsService settings;
  final VoidCallback onOpenFavorites;
  final VoidCallback onOpenSidePanel;
  final VoidCallback onFavoritesChanged;

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final GlobalKey _captureKey = GlobalKey();

  HeadlineEntry? _currentEntry;
  bool _isLiked = false;
  bool _sharing = false;

  @override
  void initState() {
    super.initState();
    generateNew();
  }

  Future<void> generateNew() async {
    final locale = await widget.settings.resolveGeneratorLocale();
    final madness = MadNews(localeOverride: locale);
    final entry = HeadlineEntry.create(
      person: madness.getPerson().trim(),
      action: madness.getAction().trim(),
      conclusion: madness.getConclusion().trim(),
      asset: headlineAssets[
          DateTime.now().millisecondsSinceEpoch % headlineAssets.length],
    );
    await widget.settings.addToHistory(entry);
    await applyEntry(entry);
  }

  Future<void> applyEntry(HeadlineEntry entry) async {
    final liked = await widget.settings.isFavorite(entry.id);
    if (!mounted) {
      return;
    }
    setState(() {
      _currentEntry = entry;
      _isLiked = liked;
    });
  }

  Future<void> toggleLike() async {
    final entry = _currentEntry;
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
    widget.onFavoritesChanged();
  }

  void onFavoriteRemovedExternally(String id) {
    if (_currentEntry?.id == id && _isLiked) {
      setState(() => _isLiked = false);
    }
  }

  Future<void> reloadLocale() async {
    final locale = await widget.settings.resolveGeneratorLocale();
    final madness = MadNews(localeOverride: locale);
    final entry = _currentEntry;
    if (entry == null) {
      return;
    }
    final updated = HeadlineEntry(
      id: entry.id,
      person: madness.getPerson().trim(),
      action: madness.getAction().trim(),
      conclusion: madness.getConclusion().trim(),
      asset: entry.asset,
      createdAt: entry.createdAt,
    );
    await applyEntry(updated);
  }

  Future<void> shareHeadline() async {
    if (_sharing) {
      return;
    }
    setState(() => _sharing = true);
    try {
      final bytes = await ScreenshotService.capturePng(_captureKey);
      if (bytes == null || !mounted) {
        return;
      }
      await showModalBottomSheet<void>(
        context: context,
        builder: (sheetContext) {
          return SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.share),
                  title: const Text('Share image'),
                  onTap: () async {
                    Navigator.pop(sheetContext);
                    final box = context.findRenderObject() as RenderBox?;
                    final origin = box != null
                        ? box.localToGlobal(Offset.zero) & box.size
                        : null;
                    await ScreenshotService.sharePng(
                      bytes,
                      sharePositionOrigin: origin,
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.save_alt),
                  title: const Text('Save to Photos'),
                  onTap: () async {
                    Navigator.pop(sheetContext);
                    await ScreenshotService.savePngToGallery(bytes);
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Saved to Photos')),
                      );
                    }
                  },
                ),
              ],
            ),
          );
        },
      );
    } finally {
      if (mounted) {
        setState(() => _sharing = false);
      }
    }
  }

  Widget _headlineText(String text, {EdgeInsetsGeometry? padding}) {
    final entry = _currentEntry;
    if (entry == null) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding:
          padding ?? const EdgeInsets.only(bottom: 10, left: 20, right: 20),
      child: Text(
        text,
        softWrap: true,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w800,
          color: Colors.white,
          backgroundColor: Colors.black87,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final entry = _currentEntry;
    if (entry == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          RepaintBoundary(
            key: _captureKey,
            child: GestureDetector(
              onTap: generateNew,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black,
                  image: DecorationImage(
                    image: AssetImage(entry.asset),
                    fit: BoxFit.cover,
                  ),
                ),
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _headlineText(
                          entry.person,
                          padding: const EdgeInsets.only(
                            top: 40,
                            bottom: 10,
                            left: 20,
                            right: 20,
                          ),
                        ),
                        _headlineText(entry.action),
                        _headlineText(
                          entry.conclusion,
                          padding: const EdgeInsets.only(
                            bottom: 20,
                            left: 20,
                            right: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  IconButton(
                    tooltip: 'Liked headlines',
                    onPressed: widget.onOpenFavorites,
                    icon: const Icon(Icons.favorite_border, color: Colors.white),
                  ),
                  const Spacer(),
                  IconButton(
                    tooltip: _isLiked ? 'Unlike' : 'Like',
                    onPressed: toggleLike,
                    icon: Icon(
                      _isLiked ? Icons.favorite : Icons.favorite_border,
                      color: _isLiked ? Colors.redAccent : Colors.white,
                    ),
                  ),
                  IconButton(
                    tooltip: 'Share',
                    onPressed: _sharing ? null : shareHeadline,
                    icon: Icon(
                      _sharing ? Icons.hourglass_top : Icons.share,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    tooltip: 'History & settings',
                    onPressed: widget.onOpenSidePanel,
                    icon: const Icon(Icons.menu, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          const Positioned(
            left: 12,
            bottom: 24,
            child: Icon(Icons.chevron_right, color: Colors.white70, size: 28),
          ),
          const Positioned(
            right: 12,
            bottom: 24,
            child: Icon(Icons.chevron_left, color: Colors.white70, size: 28),
          ),
        ],
      ),
    );
  }
}
