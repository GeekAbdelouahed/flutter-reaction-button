import 'package:avataaar_image/avataaar_image.dart';
import 'package:flutter/material.dart';

import '../models/comment.dart';

class Comments extends StatefulWidget {
  final List<Comment> comments;

  Comments(this.comments);

  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  _onSubmiteComment() {
    if (_textEditingController.text.isEmpty) return;
    setState(() {
      final comment = Comment(
        avatar: Avataaar.random(),
        name: 'Person ${widget.comments.length}',
        content: _textEditingController.text,
      );
      widget.comments.add(comment);
      _textEditingController.text = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: widget.comments.isEmpty
                ? Center(
                    child: Text(
                      'No comment yet',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  )
                : ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: widget.comments.length,
                    itemBuilder: (context, index) =>
                        buildComment(widget.comments[index]),
                  ),
          ),
        ),
        buildCommentField(),
      ],
    );
  }

  Widget buildComment(comment) => SizedBox(
        height: 75,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 40,
              width: 40,
              child: CircleAvatar(
                radius: 100,
                child: AvataaarImage(
                  avatar: comment.avatar,
                  errorImage: CircleAvatar(
                    backgroundColor: Colors.grey[200],
                    radius: 100,
                  ),
                  placeholder: CircleAvatar(
                    backgroundColor: Colors.grey[200],
                    radius: 100,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey[200],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      comment.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.black.withOpacity(.9),
                      ),
                    ),
                    Text(
                      comment.content,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        color: Colors.black.withOpacity(.75),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  Widget buildCommentField() => Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey[300].withOpacity(.5),
          borderRadius: BorderRadius.circular(30),
        ),
        child: TextFormField(
          controller: _textEditingController,
          style: TextStyle(
            fontSize: 18,
          ),
          decoration: InputDecoration(
            hintText: 'Write a comment...',
            border: InputBorder.none,
            icon: SizedBox(
              width: 10,
            ),
            suffixIcon: IconButton(
              icon: Icon(Icons.send),
              onPressed: () => _onSubmiteComment(),
            ),
          ),
          onFieldSubmitted: (_) => _onSubmiteComment(),
        ),
      );
}
