import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ScreenshotService {
  static Future<Uint8List?> capturePng(GlobalKey boundaryKey) async {
    final context = boundaryKey.currentContext;
    if (context == null) {
      return null;
    }
    final boundary = context.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) {
      return null;
    }
    final image = await boundary.toImage(pixelRatio: 3);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData?.buffer.asUint8List();
  }

  static Future<void> sharePng(
    Uint8List bytes, {
    Rect? sharePositionOrigin,
  }) async {
    final file = await _writeTempPng(bytes);
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path, mimeType: 'image/png', name: 'madnews.png')],
        sharePositionOrigin: sharePositionOrigin,
      ),
    );
  }

  static Future<void> savePngToGallery(Uint8List bytes) async {
    await Gal.putImageBytes(
      bytes,
      name: 'madnews_${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  static Future<File> _writeTempPng(Uint8List bytes) async {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/madnews_share.png');
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }
}
