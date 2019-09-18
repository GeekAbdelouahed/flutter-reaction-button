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
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Reaction Button',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Reaction Button'),
          actions: <Widget>[
            FlutterReactionButton(
              reactions: Example.flagsReactions,
              initialReaction: Example.flagsReactions[0],
              color: Colors.black.withOpacity(0.5),
              radius: 10,
              duration: Duration(milliseconds: 500),
              onReactionChanged: (reaction, selectedIndex) {
                print('reaction changed at $selectedIndex');
              },
            ),
            SizedBox(
              width: 10,
            ),
          ],
        ),
        backgroundColor: Colors.grey[200],
        body: Builder(
          builder: (context) {
            return ListView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(vertical: 5),
              children: <Widget>[
                Item(context, 'image 1', 'assets/images/img1.jpg',
                    Example.facebookReactions),
                Item(context, 'image 2', 'assets/images/img2.jpg',
                    Example.facebookReactions),
                Item(context, 'image 3', 'assets/images/img3.jpg',
                    Example.facebookReactions),
                Item(context, 'image 4', 'assets/images/img4.jpg',
                    Example.facebookReactions),
                Item(context, 'image 5', 'assets/images/img5.jpg',
                    Example.facebookReactions),
              ],
            );
          },
        ),
      ),
    );
  }
}
