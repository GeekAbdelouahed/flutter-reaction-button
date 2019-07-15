import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../flutter_reaction_button.dart';

final package = 'flutter_reaction_button';

final defaultInitialReaction = Reaction(
  previewIcon: _buildPreviewIcon('icons/like.png'),
  icon: _buildIcon('icons/like.png',
      Text('Like', style: TextStyle(color: Colors.grey[600]))),
);

final defaultSelectdReaction = defaultReactions[0];

final defaultReactions = [
  Reaction(
    previewIcon: _buildPreviewIcon('icons/like.gif'),
    icon: _buildIcon('icons/like_fill.png',
        Text('Like', style: TextStyle(color: Color(0XFF3b5998)))),
  ),
  Reaction(
    previewIcon: _buildPreviewIcon('icons/love.gif'),
    icon: _buildIcon('icons/love.png',
        Text('Love', style: TextStyle(color: Color(0XFFed5168)))),
  ),
  Reaction(
    previewIcon: _buildPreviewIcon('icons/wow.gif'),
    icon: _buildIcon('icons/wow.png',
        Text('Wow', style: TextStyle(color: Color(0XFFffda6b)))),
  ),
  Reaction(
    previewIcon: _buildPreviewIcon('icons/haha.gif'),
    icon: _buildIcon('icons/haha.png',
        Text('Haha', style: TextStyle(color: Color(0XFFffda6b)))),
  ),
  Reaction(
    previewIcon: _buildPreviewIcon('icons/sad.gif'),
    icon: _buildIcon('icons/sad.png',
        Text('Sad', style: TextStyle(color: Color(0XFFffda6b)))),
  ),
  Reaction(
      previewIcon: _buildPreviewIcon('icons/angry.gif'),
      icon: _buildIcon('icons/angry.png',
          Text('Angry', style: TextStyle(color: Color(0XFFf05766))))),
];

Widget _buildPreviewIcon(String path) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 3.5, vertical: 5),
    child: Image.asset(path, package: package, height: 40),
  );
}

Widget _buildIcon(String path, Text text) {
  return Container(
    color: Colors.transparent,
    child: Row(
      children: <Widget>[
        Image.asset(path, package: package, height: 20),
        SizedBox(
          width: 5,
        ),
        text,
      ],
    ),
  );
}
