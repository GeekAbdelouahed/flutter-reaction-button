import 'package:avataaar_image/avataaar_image.dart';
import 'package:flutter/material.dart';

class Comments extends StatefulWidget {
  final List<String> comments;

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
    setState(() {
      widget.comments.add(_textEditingController.text);
      _textEditingController.text = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
                    itemBuilder: (context, index) => buildComment(index),
                  ),
          ),
        ),
        buildCommentField(),
      ],
    );
  }

  Widget buildComment(int index) => SizedBox(
        height: 70,
        child: Row(
          children: [
            SizedBox(
              width: 35,
              child: CircleAvatar(
                radius: 100,
                child: AvataaarImage(
                  avatar: Avataaar.random(),
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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.grey[200],
              ),
              child: Text(
                widget.comments[index],
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                  color: Colors.black.withOpacity(.75),
                ),
              ),
            )
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
