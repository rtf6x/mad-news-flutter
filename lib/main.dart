import 'package:flutter/foundation.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'src/generator.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

void main() {
  Crashlytics.instance.enableInDevMode = true;
  FlutterError.onError = Crashlytics.instance.recordFlutterError;
  runApp(VideoApp());
}

class VideoApp extends StatefulWidget {
  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  VideoPlayerController _controller;
  String person = '';
  String action = '';
  String conclusion = '';

  @override
  void initState() {
    var madness = new MadNews();
    this.person = madness.getPerson().trim();
    this.action = madness.getAction().trim();
    this.conclusion = madness.getConclusion().trim();
    super.initState();
    _controller = VideoPlayerController.asset("assets/shower.mp4")
      ..initialize().then((_) {
        _controller.play();
        _controller.setLooping(true);
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  void reloadMadness() {
    var madness = new MadNews();
    this.person = madness.getPerson().trim();
    this.action = madness.getAction().trim();
    this.conclusion = madness.getConclusion().trim();
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MadNews',
      home: SafeArea(
        child: Scaffold(
          body: GestureDetector(
            onTap: () {
              this.reloadMadness();
            },
            child: Stack(children: <Widget>[
              SizedBox.expand(
                child: FittedBox(
                  fit: BoxFit.fitHeight,
                  alignment: Alignment.bottomLeft,
                  child: SizedBox(
                    width: _controller.value.size?.width ?? 0,
                    height: _controller.value.size?.height ?? 0,
                    child: _controller.value.initialized
                        ? AspectRatio(
                            aspectRatio: _controller.value.aspectRatio,
                            child: VideoPlayer(_controller),
                          )
                        : Container(),
                  ),
                ),
              ),
              FittedBox(
                fit: BoxFit.fitHeight,
                alignment: Alignment.bottomLeft,
                child: SizedBox(
                  width: 300,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            top: 40, bottom: 10, left: 20, right: 20),
                        child: Text(
                          '${this.person}',
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
                          '${this.action}',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            backgroundColor: Colors.black87,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 20, left: 20, right: 20),
                        child: Text(
                          '${this.conclusion}',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            backgroundColor: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
