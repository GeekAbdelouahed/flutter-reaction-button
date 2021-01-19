import 'package:flutter/material.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'data/example_data.dart' as Example;

import 'items/item.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Reaction Button',
        home: Scaffold(
          backgroundColor: Colors.grey[200],
          appBar: AppBar(
            title: const Text('Flutter Reaction Button'),
            actions: [
              Builder(
                builder: (ctx) => FlutterReactionButton(
                  onReactionChanged: (reaction, index) {
                    Scaffold.of(ctx).showSnackBar(
                      SnackBar(
                        content: Text('reaction selected index: $index'),
                      ),
                    );
                  },
                  reactions: Example.flagsReactions,
                  initialReaction: Reaction(icon: Icon(Icons.language)),
                  boxColor: Colors.black.withOpacity(0.5),
                  boxRadius: 10,
                  boxDuration: Duration(milliseconds: 500),
                  boxAlignment: AlignmentDirectional.bottomEnd,
                ),
              ),
              SizedBox(width: 10),
            ],
          ),
          body: Builder(
            builder: (context) => ListView(
              padding: const EdgeInsets.symmetric(vertical: 5),
              children: [
                Item(
                  'image 1',
                  'assets/images/img1.jpg',
                  Example.reactions,
                ),
                Item(
                  'image 2',
                  'assets/images/img2.jpg',
                  Example.reactions,
                ),
                Item(
                  'image 3',
                  'assets/images/img3.jpg',
                  Example.reactions,
                ),
                Item(
                  'image 4',
                  'assets/images/img4.jpg',
                  Example.reactions,
                ),
                Item(
                  'image 5',
                  'assets/images/img5.jpg',
                  Example.reactions,
                ),
              ],
            ),
          ),
        ),
      );
}
