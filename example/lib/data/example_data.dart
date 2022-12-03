import 'package:flutter/material.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';

List<Reaction<String>> flagsReactions = [
  Reaction<String>(
    value: 'en',
    previewIcon: _buildFlagsPreviewIcon(
        'assets/images/united-kingdom-round.png', 'English'),
    icon: _buildIcon('assets/images/united-kingdom.png'),
  ),
  Reaction<String>(
    value: 'ar',
    previewIcon:
        _buildFlagsPreviewIcon('assets/images/algeria-round.png', 'Arabic'),
    icon: _buildIcon('assets/images/algeria.png'),
  ),
  Reaction<String>(
    value: 'gr',
    previewIcon:
        _buildFlagsPreviewIcon('assets/images/germany-round.png', 'German'),
    icon: _buildIcon('assets/images/germany.png'),
  ),
  Reaction<String>(
    value: 'sp',
    previewIcon:
        _buildFlagsPreviewIcon('assets/images/spain-round.png', 'Spanish'),
    icon: _buildIcon('assets/images/spain.png'),
  ),
  Reaction<String>(
    value: 'ch',
    previewIcon:
        _buildFlagsPreviewIcon('assets/images/china-round.png', 'Chinese'),
    icon: _buildIcon('assets/images/china.png'),
  ),
];

final defaultInitialReaction = Reaction<String>(
  value: null,
  icon: const Text('No reaction'),
);

final reactions = [
  Reaction<String>(
    value: 'Happy',
    title: _buildTitle('Happy'),
    previewIcon: _buildReactionsPreviewIcon('assets/images/happy.png'),
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
    title: _buildTitle('Angry'),
    previewIcon: _buildReactionsPreviewIcon('assets/images/angry.png'),
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
    title: _buildTitle('In love'),
    previewIcon: _buildReactionsPreviewIcon('assets/images/in-love.png'),
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
    title: _buildTitle('Sad'),
    previewIcon: _buildReactionsPreviewIcon('assets/images/sad.png'),
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
    title: _buildTitle('Surprised'),
    previewIcon: _buildReactionsPreviewIcon('assets/images/surprised.png'),
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
    title: _buildTitle('Mad'),
    previewIcon: _buildReactionsPreviewIcon('assets/images/mad.png'),
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

Padding _buildFlagsPreviewIcon(String path, String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    child: Column(
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
    ),
  );
}

Container _buildTitle(String title) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 7.5, vertical: 2.5),
    decoration: BoxDecoration(
      color: Colors.red,
      borderRadius: BorderRadius.circular(15),
    ),
    child: Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 10,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

Padding _buildReactionsPreviewIcon(String path) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 3.5, vertical: 5),
    child: Image.asset(path, height: 40),
  );
}

Image _buildIcon(String path) {
  return Image.asset(
    path,
    height: 30,
    width: 30,
  );
}

Container _buildReactionsIcon(String path, Text text) {
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
