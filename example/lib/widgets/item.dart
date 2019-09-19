import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:flutter/material.dart';
import 'comments.dart';
import '../models/comment.dart';
import '../data/example_data.dart' as Example;

class Item extends StatefulWidget {
  final BuildContext context;
  final String title;
  final String imgPath;
  final List<Reaction> reactions;

  const Item(this.context, this.title, this.imgPath, this.reactions);

  @override
  _ItemState createState() => _ItemState();
}

class _ItemState extends State<Item> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  List<Comment> _comments = [];

  _showBottomSheetCommets() {
    showBottomSheet(
      context: widget.context,
      builder: (context) => Comments(_comments),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      elevation: 2,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        child: Column(
          children: <Widget>[
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
              margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              height: 1,
              color: Colors.grey[300],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FlutterReactionButtonCheck(
                  onReactionChanged: (reaction, selectedIndex, isChecked) {
                    print('reaction changed at $selectedIndex');
                  },
                  reactions: widget.reactions,
                  initialReaction: Example.defaultInitialReaction,
                  selectedReaction: widget.reactions[0],
                ),
                SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () => _showBottomSheetCommets(),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.message,
                        size: 20,
                        color: Colors.grey[400],
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Comment',
                        style: TextStyle(fontSize: 17, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () => Scaffold.of(context).showSnackBar(SnackBar(
                    duration: Duration(seconds: 2),
                    content: Text(
                      'Sahre image ${widget.title}',
                      style: TextStyle(color: Colors.white),
                    ),
                  )),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.share,
                        size: 20,
                        color: Colors.grey[400],
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Share',
                        style: TextStyle(fontSize: 17, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              height: 1,
              color: Colors.grey[200],
            ),
          ],
        ),
      ),
    );
  }
}
