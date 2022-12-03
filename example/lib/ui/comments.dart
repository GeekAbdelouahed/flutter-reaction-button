import 'package:flutter/material.dart';

import '../models/comment.dart';

class Comments extends StatefulWidget {
  const Comments({Key? key, required this.comments}) : super(key: key);

  final List<Comment> comments;

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  void _onSubmitComment() {
    if (_textEditingController.text.isEmpty) return;
    setState(() {
      final comment = Comment(
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
        const SizedBox(height: 20),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: widget.comments.isEmpty
                ? const Center(
                    child: Text(
                      'No comment yet',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  )
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: widget.comments.length,
                    itemBuilder: (context, index) {
                      return buildComment(widget.comments[index]);
                    },
                  ),
          ),
        ),
        buildCommentField(),
      ],
    );
  }

  SizedBox buildComment(Comment comment) {
    return SizedBox(
      height: 75,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 40,
            width: 40,
            child: CircleAvatar(
              radius: 100,
              child: CircleAvatar(
                child: Text(
                  comment.name.substring(0, 1).toUpperCase(),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
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
  }

  Container buildCommentField() {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[300]?.withOpacity(.5),
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextFormField(
        controller: _textEditingController,
        style: const TextStyle(
          fontSize: 18,
        ),
        decoration: InputDecoration(
          hintText: 'Write a comment...',
          border: InputBorder.none,
          icon: const SizedBox(
            width: 10,
          ),
          suffixIcon: IconButton(
            icon: const Icon(Icons.send),
            onPressed: _onSubmitComment,
          ),
        ),
        onFieldSubmitted: (_) => _onSubmitComment(),
      ),
    );
  }
}
