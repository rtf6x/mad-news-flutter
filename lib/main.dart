import 'dart:ui';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'src/generator.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

// Import the firebase_core plugin
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  runApp(VideoApp());
}

class VideoApp extends StatefulWidget {
  const VideoApp({Key? key}) : super(key: key);

  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  late VideoPlayerController _controller;
  String person = '';
  String action = '';
  String conclusion = '';

  @override
  void initState() {
    var madness = MadNews();
    person = madness.getPerson().trim();
    action = madness.getAction().trim();
    conclusion = madness.getConclusion().trim();
    super.initState();
    print('initState');
    _controller = VideoPlayerController.asset("assets/shower.mp4")..initialize().then((_) {
      print('play');
      _controller.play();
      print('setLooping');
      _controller.setLooping(true);
      print('setState');
      // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
      setState(() {});
    });
  }

  void reloadMadness() {
    var madness = new MadNews();
    person = madness.getPerson().trim();
    action = madness.getAction().trim();
    conclusion = madness.getConclusion().trim();
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Widget madContent(BuildContext context) {
    double width = window.physicalSize.width;
    return SizedBox(
        width: width / 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[

            Padding(
              padding:
              EdgeInsets.only(top: 40, bottom: 10, left: 20, right: 20),
              child: Text(
                person,
                softWrap: true,
                overflow: TextOverflow.visible,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  backgroundColor: Colors.black87,
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(bottom: 10, left: 20, right: 20),
              child: Text(
                  action,
                  softWrap: true,
                  overflow: TextOverflow.visible,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    decoration: TextDecoration.combine([

                    ]),
                    color: Colors.white,
                    backgroundColor: Colors.black87,
                  )
              ),
            ),

            Padding(
              padding: EdgeInsets.only(bottom: 20, left: 20, right: 20),
              child: Text(
                conclusion,
                softWrap: true,
                overflow: TextOverflow.visible,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  backgroundColor: Colors.black87,
                ),
              ),
            ),
          ],
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MadNews',
      home: SafeArea(
        child: Scaffold(
          body: GestureDetector(
            onTap: () {
              reloadMadness();
            },
            child: Stack(children: <Widget>[
              SizedBox.expand(
                child: FittedBox(
                  fit: BoxFit.fitHeight,
                  alignment: Alignment.topLeft,
                  child: SizedBox(
                    width: _controller.value.size.width,
                    height: _controller.value.size.height,
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                  ),
                ),
              ),
              FittedBox(
                fit: BoxFit.fitHeight,
                alignment: Alignment.bottomLeft,
                child: madContent(context),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
