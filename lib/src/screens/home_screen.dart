import 'package:flutter/material.dart';

import '../models/headline_entry.dart';
import '../services/screenshot_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.entry,
    required this.isLiked,
    required this.blockGenerate,
    required this.onGenerateNew,
    required this.onToggleLike,
    required this.onOpenFavorites,
    required this.onOpenSidePanel,
  });

  final HeadlineEntry entry;
  final bool isLiked;
  final bool blockGenerate;
  final VoidCallback onGenerateNew;
  final VoidCallback onToggleLike;
  final VoidCallback onOpenFavorites;
  final VoidCallback onOpenSidePanel;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey _captureKey = GlobalKey();
  bool _sharing = false;

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

  Widget _refreshHint() {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.black87,
        shape: BoxShape.circle,
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Icon(
          Icons.refresh,
          color: widget.blockGenerate ? Colors.white38 : Colors.white,
          size: 28,
        ),
      ),
    );
  }

  Widget _headlineText(String text, {EdgeInsetsGeometry? padding}) {
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
    final entry = widget.entry;
    final width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          RepaintBoundary(
            key: _captureKey,
            child: GestureDetector(
              onTap: widget.blockGenerate ? null : widget.onGenerateNew,
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
                            bottom: 10,
                            left: 20,
                            right: 20,
                          ),
                        ),
                        IgnorePointer(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 20,
                              bottom: 20,
                            ),
                            child: _refreshHint(),
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
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      tooltip: 'Liked headlines',
                      onPressed: widget.onOpenFavorites,
                      icon: const Icon(
                        Icons.chevron_left,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          tooltip: widget.isLiked ? 'Unlike' : 'Like',
                          onPressed: widget.onToggleLike,
                          icon: Icon(
                            widget.isLiked
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: widget.isLiked
                                ? Colors.redAccent
                                : Colors.white,
                            size: 28,
                          ),
                        ),
                        IconButton(
                          tooltip: 'Share',
                          onPressed: _sharing ? null : shareHeadline,
                          icon: Icon(
                            _sharing ? Icons.hourglass_top : Icons.share,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      tooltip: 'History & settings',
                      onPressed: widget.onOpenSidePanel,
                      icon: const Icon(
                        Icons.chevron_right,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
