import 'package:flutter/material.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:flutter_reaction_button_test/data.dart' as data;
import 'package:flutter_reaction_button_test/image.dart';
import 'package:flutter_reaction_button_test/post.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

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
              builder: (context) {
                return SizedBox.square(
                  dimension: 30,
                  child: ReactionButton<String>(
                    toggle: false,
                    onReactionChanged: (String? value) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Selected language: $value'),
                        ),
                      );
                    },
                    reactions: data.flagsReactions,
                    placeholder: const Reaction<String>(
                      value: null,
                      icon: Icon(
                        Icons.language,
                      ),
                    ),
                    boxColor: Colors.black.withOpacity(0.5),
                    boxRadius: 10,
                    boxReactionSpacing: 20,
                    itemSize: const Size(40, 60),
                  ),
                );
              },
            ),
            const SizedBox(width: 10),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Column(
            children: [
              PostWidget(
                title: 'image 1',
                imgPath: 'assets/images/img1.jpg',
                reactions: data.reactions,
              ),
              ImageWidget(
                imgPath: 'assets/images/img1.jpg',
                reactions: data.reactions,
              ),
              PostWidget(
                title: 'image 2',
                imgPath: 'assets/images/img2.jpg',
                reactions: data.reactions,
              ),
              ImageWidget(
                imgPath: 'assets/images/img2.jpg',
                reactions: data.reactions,
              ),
              PostWidget(
                title: 'image 3',
                imgPath: 'assets/images/img3.jpg',
                reactions: data.reactions,
              ),
              ImageWidget(
                imgPath: 'assets/images/img3.jpg',
                reactions: data.reactions,
              ),
              PostWidget(
                title: 'image 4',
                imgPath: 'assets/images/img4.jpg',
                reactions: data.reactions,
              ),
              ImageWidget(
                imgPath: 'assets/images/img4.jpg',
                reactions: data.reactions,
              ),
              PostWidget(
                title: 'image 5',
                imgPath: 'assets/images/img5.jpg',
                reactions: data.reactions,
              ),
              ImageWidget(
                imgPath: 'assets/images/img5.jpg',
                reactions: data.reactions,
              ),
              const SafeArea(
                child: SizedBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
