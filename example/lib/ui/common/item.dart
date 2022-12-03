import 'package:flutter/material.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';

import '../../data/example_data.dart' as example;
import '../../models/comment.dart';
import '../comments.dart';

class Item extends StatefulWidget {
  const Item({
    Key? key,
    required this.title,
    required this.imgPath,
    required this.reactions,
  }) : super(key: key);

  final String title;
  final String imgPath;
  final List<Reaction<String>> reactions;

  @override
  State<Item> createState() => _ItemState();
}

class _ItemState extends State<Item> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final List<Comment> _comments = [];

  void _showBottomSheetComments() {
    showBottomSheet(
      context: context,
      builder: (context) {
        return Comments(comments: _comments);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
                widget.imgPath,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              height: 1,
              color: Colors.grey[300],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .2,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: ReactionButtonToggle<String>(
                        onReactionChanged: (String? value, bool isChecked) {
                          debugPrint(
                              'Selected value: $value, isChecked: $isChecked');
                        },
                        reactions: widget.reactions,
                        initialReaction: example.defaultInitialReaction,
                        selectedReaction: widget.reactions[1],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => _showBottomSheetComments(),
                    child: Row(
                      children: [
                        Icon(
                          Icons.message,
                          size: 20,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'Comment',
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: const Duration(seconds: 2),
                          content: Text(
                            'Share image ${widget.title}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    },
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.share,
                          size: 20,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'Share',
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              height: 1,
              color: Colors.grey[200],
            ),
          ],
        ),
      ),
    );
  }
}
