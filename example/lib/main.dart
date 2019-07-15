import 'package:flutter/material.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import './example_data.dart' as Example;

import 'item.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Reaction Button',
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Flutter Reaction Button'),
            actions: <Widget>[
              FlutterReactionButton(
                reactions: Example.menuReactions,
                initialReaction: Example.menuReactions[0],
                color: Colors.black.withOpacity(0.5),
                radius: 10,
                duration: Duration(milliseconds: 500),
                onReactionChanged: (reaction) {
                  print('reaction changed');
                },
              ),
              SizedBox(
                width: 10,
              ),
            ],
          ),
          backgroundColor: Colors.grey[200],
          body: Builder(
            builder: (context) => ListView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(vertical: 5),
              children: <Widget>[
                Item('image 1', 'assets/images/img1.jpg'),
                Item('image 2', 'assets/images/img2.jpg'),
                Item('image 3', 'assets/images/img3.jpg'),
                Item('image 4', 'assets/images/img4.jpg'),
                Item('image 5', 'assets/images/img5.jpg'),
              ],
            ),
          )),
    );
  }
}
