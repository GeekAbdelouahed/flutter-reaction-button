import 'package:flutter/material.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';

const Reaction _placeHolder = Reaction(
  value: 0,
  icon: Icon(Icons.sunny_snowing),
);

const List<Reaction> _reactions = [
  Reaction(
    value: 1,
    icon: Icon(Icons.ac_unit),
  ),
  Reaction(
    value: 2,
    icon: Icon(Icons.sunny),
  ),
  Reaction(
    value: 3,
    icon: Icon(Icons.wind_power),
  ),
];

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    this.toggle = true,
  });

  final bool toggle;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Column(
            children: List.generate(
              10,
              (index) {
                return ReactionButton(
                  toggle: toggle,
                  onReactionChanged: (reaction) {},
                  reactions: _reactions,
                  placeholder: _placeHolder,
                  itemSize: const Size.square(24),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
