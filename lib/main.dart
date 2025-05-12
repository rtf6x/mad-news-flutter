import 'dart:math';

import 'package:flutter/material.dart';
import 'src/generator.dart';

void main() {
  runApp(_BaseLayout());
}

class _BaseLayout extends StatefulWidget{
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<_BaseLayout> {
  String person = '';
  String action = '';
  String conclusion = '';
  String asset = '';
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
    var madness = MadNews();
    person = madness.getPerson().trim();
    action = madness.getAction().trim();
    conclusion = madness.getConclusion().trim();
    asset = assets[Random().nextInt(assets.length)];
    super.initState();
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
  }

  Widget madContent(BuildContext context) {
    final Size size = View.of(context).physicalSize;
    final double width = size.width;
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
        ));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MadNews',
      home: Scaffold(
        body: GestureDetector(
          onTap: () {
            reloadMadness();
          },
          child: Container(
            // constraints: BoxConstraints.expand(),
            height: double.infinity,
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
              child: madContent(context),
            ),
          ),
        ),
      )
    );
  }
}
