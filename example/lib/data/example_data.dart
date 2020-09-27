import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';

List<Reaction> flagsReactions = [
  Reaction(
    id: 1,
    previewIcon:
        _buildPreviewIcon('assets/images/united-kingdom-round.png', 'English'),
    icon: _buildIcon('assets/images/united-kingdom.png'),
  ),
  Reaction(
    id: 2,
    previewIcon: _buildPreviewIcon('assets/images/algeria-round.png', 'Arabic'),
    icon: _buildIcon('assets/images/algeria.png'),
  ),
  Reaction(
    id: 3,
    enabled: false,
    previewIcon: _buildPreviewIcon('assets/images/germany-round.png', 'German'),
    icon: _buildIcon('assets/images/germany.png'),
  ),
  Reaction(
    id: 4,
    previewIcon: _buildPreviewIcon('assets/images/spain-round.png', 'Spanish'),
    icon: _buildIcon('assets/images/spain.png'),
  ),
  Reaction(
    id: 5,
    previewIcon: _buildPreviewIcon('assets/images/china-round.png', 'Chinese'),
    icon: _buildIcon('assets/images/china.png'),
  ),
];

final defaultInitialReaction = Reaction(
  id: 0,
  icon: Text('No raction'),
);

final reactions = [
  Reaction(
    id: 1,
    previewIcon: _buildPreviewIconFacebook('assets/images/happy.png'),
    icon: _buildIconFacebook(
      'assets/images/happy.png',
      Text(
        'Happy',
        style: TextStyle(
          color: Color(0XFF3b5998),
        ),
      ),
    ),
  ),
  Reaction(
    id: 2,
    previewIcon: _buildPreviewIconFacebook('assets/images/angry.png'),
    icon: _buildIconFacebook(
      'assets/images/angry.png',
      Text(
        'Angry',
        style: TextStyle(
          color: Color(0XFFed5168),
        ),
      ),
    ),
  ),
  Reaction(
    id: 3,
    previewIcon: _buildPreviewIconFacebook('assets/images/in-love.png'),
    icon: _buildIconFacebook(
      'assets/images/in-love.png',
      Text(
        'In love',
        style: TextStyle(
          color: Color(0XFFffda6b),
        ),
      ),
    ),
  ),
  Reaction(
    id: 4,
    previewIcon: _buildPreviewIconFacebook('assets/images/sad.png'),
    icon: _buildIconFacebook(
      'assets/images/sad.png',
      Text(
        'Sad',
        style: TextStyle(
          color: Color(0XFFffda6b),
        ),
      ),
    ),
  ),
  Reaction(
    id: 5,
    previewIcon: _buildPreviewIconFacebook('assets/images/surprised.png'),
    icon: _buildIconFacebook(
      'assets/images/surprised.png',
      Text(
        'Surprised',
        style: TextStyle(
          color: Color(0XFFffda6b),
        ),
      ),
    ),
  ),
  Reaction(
    id: 6,
    previewIcon: _buildPreviewIconFacebook('assets/images/mad.png'),
    icon: _buildIconFacebook(
      'assets/images/mad.png',
      Text(
        'Mad',
        style: TextStyle(
          color: Color(0XFFf05766),
        ),
      ),
    ),
  ),
];

Widget _buildPreviewIcon(String path, String text) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w300,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 7.5),
          Image.asset(path, height: 30),
        ],
      ),
    );

Widget _buildPreviewIconFacebook(String path) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3.5, vertical: 5),
      child: Image.asset(path, height: 40),
    );

Widget _buildIcon(String path) => Image.asset(
      path,
      height: 30,
      width: 30,
    );

Widget _buildIconFacebook(String path, Text text) => Container(
      color: Colors.transparent,
      child: Row(
        children: <Widget>[
          Image.asset(path, height: 20),
          const SizedBox(width: 5),
          text,
        ],
      ),
    );
