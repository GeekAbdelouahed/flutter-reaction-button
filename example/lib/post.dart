import 'package:flutter/material.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:flutter_reaction_button_test/data.dart' as data;

class PostWidget extends StatelessWidget {
  const PostWidget({
    Key? key,
    required this.title,
    required this.imgPath,
    required this.reactions,
  }) : super(key: key);

  final String title;
  final String imgPath;
  final List<Reaction<String>> reactions;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      elevation: 2,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(
          Radius.circular(5),
        ),
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 2,
              child: Image.asset(
                imgPath,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              height: 55,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ReactionButton<String>(
                    key: ValueKey(imgPath),
                    itemSize: const Size.square(40),
                    onReactionChanged: (String? value) {
                      debugPrint('Selected value: $value');
                    },
                    reactions: reactions,
                    initialReaction: data.defaultInitialReaction,
                    selectedReaction: reactions.first,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.message,
                        size: 16,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'Comment',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.share,
                        size: 16,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'Share',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
