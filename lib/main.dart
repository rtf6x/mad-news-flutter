import 'dart:math';

import 'package:flutter/material.dart';
import 'src/generator.dart';

void main() {
  runApp(_App());
}

class _App extends StatefulWidget{
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<_App> {
  String person = '';
  String action = '';
  String conclusion = '';
  String asset = 'assets/bg.jpg';
  List assets = [
    'assets/bg.jpg',
    'assets/bg2.jpg',
    'assets/bg3.jpg',
    'assets/bg4.jpg',
    'assets/bg5.jpg',
    'assets/bg6.jpg',
  ];

  @override
  void initState() {
    super.initState();
    reloadMadness();
  }

  void reloadMadness() {
    var madness = MadNews();
    person = madness.getPerson().trim();
    action = madness.getAction().trim();
    conclusion = madness.getConclusion().trim();
    asset = assets[Random().nextInt(assets.length)];
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    reloadMadness();
  }

  Widget madContent(double width) {
    return SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 40, bottom: 10, left: 20, right: 20),
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
        ));
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.sizeOf(context).height;
    final double width = MediaQuery.sizeOf(context).width;
    return MaterialApp(
      title: 'MadNews',
      color: Colors.transparent,
      home: Scaffold(
        backgroundColor: Colors.transparent,
        body: GestureDetector(
          onTap: () {
            reloadMadness();
          },
          child: Container(
            constraints: BoxConstraints.expand(),
            height: height,
            decoration: BoxDecoration(
              color: Colors.black,
              image: DecorationImage(
                image: AssetImage(asset),
                fit: BoxFit.cover,
              ),
            ),
            child: FittedBox(
              fit: BoxFit.fitWidth,
              alignment: Alignment.center,
              child: madContent(width),
            ),
          ),
        ),
      )
    );
  }
}
