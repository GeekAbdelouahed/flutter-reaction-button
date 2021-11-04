import 'package:flutter/material.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';

import '../data/example_data.dart' as Example;
import 'common/item.dart';
import 'common/item_container.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Reaction Button',
      home: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: const Text('Flutter Reaction Button'),
          actions: [
            Builder(
              builder: (ctx) {
                return ReactionButton<String>(
                  onReactionChanged: (String? value) {
                    ScaffoldMessenger.of(ctx).showSnackBar(
                      SnackBar(
                        content: Text('Selected value: $value'),
                      ),
                    );
                  },
                  reactions: Example.flagsReactions,
                  initialReaction: Reaction<String>(
                    value: null,
                    icon: Icon(
                      Icons.language,
                    ),
                  ),
                  boxColor: Colors.black.withOpacity(0.5),
                  boxRadius: 10,
                  boxDuration: Duration(milliseconds: 500),
                  itemScaleDuration: const Duration(milliseconds: 200),
                );
              },
            ),
            SizedBox(width: 10),
          ],
        ),
        body: Builder(
          builder: (_) {
            return ListView(
              padding: const EdgeInsets.symmetric(vertical: 5),
              children: [
                Item(
                  'image 1',
                  'assets/images/img1.jpg',
                  Example.reactions,
                ),
                ItemContainer(
                  'assets/images/img1.jpg',
                  Example.reactions,
                ),
                Item(
                  'image 2',
                  'assets/images/img2.jpg',
                  Example.reactions,
                ),
                ItemContainer(
                  'assets/images/img2.jpg',
                  Example.reactions,
                ),
                Item(
                  'image 3',
                  'assets/images/img3.jpg',
                  Example.reactions,
                ),
                ItemContainer(
                  'assets/images/img3.jpg',
                  Example.reactions,
                ),
                Item(
                  'image 4',
                  'assets/images/img4.jpg',
                  Example.reactions,
                ),
                ItemContainer(
                  'assets/images/img4.jpg',
                  Example.reactions,
                ),
                Item(
                  'image 5',
                  'assets/images/img5.jpg',
                  Example.reactions,
                ),
                ItemContainer(
                  'assets/images/img5.jpg',
                  Example.reactions,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
