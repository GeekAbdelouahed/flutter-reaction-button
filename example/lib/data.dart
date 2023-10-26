import 'package:flutter/material.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';

final List<Reaction<String>> flagsReactions = [
  Reaction<String>(
    value: 'en',
    previewIcon: _buildFlagPreviewIcon(
      'assets/images/united-kingdom-round.png',
      'English',
    ),
    icon: _buildFlagIcon(
      'assets/images/united-kingdom.png',
    ),
  ),
  Reaction<String>(
    value: 'ar',
    previewIcon: _buildFlagPreviewIcon(
      'assets/images/algeria-round.png',
      'Arabic',
    ),
    icon: _buildFlagIcon(
      'assets/images/algeria.png',
    ),
  ),
  Reaction<String>(
    value: 'gr',
    previewIcon: _buildFlagPreviewIcon(
      'assets/images/germany-round.png',
      'German',
    ),
    icon: _buildFlagIcon(
      'assets/images/germany.png',
    ),
  ),
  Reaction<String>(
    value: 'sp',
    previewIcon: _buildFlagPreviewIcon(
      'assets/images/spain-round.png',
      'Spanish',
    ),
    icon: _buildFlagIcon(
      'assets/images/spain.png',
    ),
  ),
  Reaction<String>(
    value: 'ch',
    previewIcon: _buildFlagPreviewIcon(
      'assets/images/china-round.png',
      'Chinese',
    ),
    icon: _buildFlagIcon(
      'assets/images/china.png',
    ),
  ),
];

const defaultInitialReaction = Reaction<String>(
  value: null,
  icon: Text(
    'No reaction',
  ),
);

final List<Reaction<String>> reactions = [
  Reaction<String>(
    value: 'Happy',
    title: _buildEmojiTitle(
      'Happy',
    ),
    previewIcon: _buildEmojiPreviewIcon(
      'assets/images/happy.png',
    ),
    icon: _buildReactionsIcon(
      'assets/images/happy.png',
      const Text(
        'Happy',
        style: TextStyle(
          color: Color(0XFF3b5998),
        ),
      ),
    ),
  ),
  Reaction<String>(
    value: 'Angry',
    title: _buildEmojiTitle(
      'Angry',
    ),
    previewIcon: _buildEmojiPreviewIcon(
      'assets/images/angry.png',
    ),
    icon: _buildReactionsIcon(
      'assets/images/angry.png',
      const Text(
        'Angry',
        style: TextStyle(
          color: Color(0XFFed5168),
        ),
      ),
    ),
  ),
  Reaction<String>(
    value: 'In love',
    title: _buildEmojiTitle(
      'In love',
    ),
    previewIcon: _buildEmojiPreviewIcon(
      'assets/images/in-love.png',
    ),
    icon: _buildReactionsIcon(
      'assets/images/in-love.png',
      const Text(
        'In love',
        style: TextStyle(
          color: Color(0XFFffda6b),
        ),
      ),
    ),
  ),
  Reaction<String>(
    value: 'Sad',
    title: _buildEmojiTitle(
      'Sad',
    ),
    previewIcon: _buildEmojiPreviewIcon(
      'assets/images/sad.png',
    ),
    icon: _buildReactionsIcon(
      'assets/images/sad.png',
      const Text(
        'Sad',
        style: TextStyle(
          color: Color(0XFFffda6b),
        ),
      ),
    ),
  ),
  Reaction<String>(
    value: 'Surprised',
    title: _buildEmojiTitle(
      'Surprised',
    ),
    previewIcon: _buildEmojiPreviewIcon(
      'assets/images/surprised.png',
    ),
    icon: _buildReactionsIcon(
      'assets/images/surprised.png',
      const Text(
        'Surprised',
        style: TextStyle(
          color: Color(0XFFffda6b),
        ),
      ),
    ),
  ),
  Reaction<String>(
    value: 'Mad',
    title: _buildEmojiTitle(
      'Mad',
    ),
    previewIcon: _buildEmojiPreviewIcon(
      'assets/images/mad.png',
    ),
    icon: _buildReactionsIcon(
      'assets/images/mad.png',
      const Text(
        'Mad',
        style: TextStyle(
          color: Color(0XFFf05766),
        ),
      ),
    ),
  ),
];

Widget _buildFlagPreviewIcon(String path, String text) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        text,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w300,
          color: Colors.white,
        ),
      ),
      const SizedBox(height: 7.5),
      Image.asset(path, height: 30),
    ],
  );
}

Widget _buildEmojiTitle(String title) {
  return Container(
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: Colors.black.withOpacity(.75),
      borderRadius: BorderRadius.circular(15),
    ),
    child: Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 8,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

Widget _buildEmojiPreviewIcon(String path) {
  return Image.asset(path);
}

Widget _buildFlagIcon(String path) {
  return Image.asset(path);
}

Widget _buildReactionsIcon(String path, Text text) {
  return Container(
    color: Colors.transparent,
    child: Row(
      children: <Widget>[
        Image.asset(path, height: 20),
        const SizedBox(width: 5),
        text,
      ],
    ),
  );
}
