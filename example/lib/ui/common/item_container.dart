import 'package:flutter/material.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';

class ItemContainer extends StatefulWidget {
  final String imgPath;
  final List<Reaction<String>> reactions;

  const ItemContainer(this.imgPath, this.reactions);

  @override
  _ItemContainerState createState() => _ItemContainerState();
}

class _ItemContainerState extends State<ItemContainer>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      child: ReactionContainer<String>(
        onReactionChanged: (String? value) {
          print('Selected value: $value');
        },
        reactions: widget.reactions,
        child: AspectRatio(
          aspectRatio: 2,
          child: Image.asset(
            widget.imgPath,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
