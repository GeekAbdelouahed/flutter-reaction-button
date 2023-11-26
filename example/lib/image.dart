import 'package:flutter/material.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';

class ImageWidget extends StatefulWidget {
  const ImageWidget({
    Key? key,
    required this.imgPath,
    required this.reactions,
  }) : super(key: key);

  final String imgPath;
  final List<Reaction<String>> reactions;

  @override
  State<ImageWidget> createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<ImageWidget> {
  Reaction<String>? _selectedReaction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      child: AspectRatio(
        aspectRatio: 2,
        child: Stack(
          children: [
            Card(
              margin: EdgeInsets.zero,
              elevation: 2,
              clipBehavior: Clip.antiAlias,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
              child: ReactionButton<String>(
                onReactionChanged: (Reaction<String>? reaction) {
                  setState(() {
                    _selectedReaction = reaction;
                  });
                  debugPrint('Selected value: ${reaction?.value}');
                },
                itemSize: const Size.square(40),
                reactions: widget.reactions,
                child: Image.asset(
                  widget.imgPath,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            PositionedDirectional(
              end: 5,
              bottom: 5,
              child: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(.35),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.3),
                      offset: const Offset(0, 3),
                      blurRadius: 3,
                    )
                  ],
                ),
                child: _selectedReaction?.previewIcon,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
