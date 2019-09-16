import 'package:flutter/material.dart';
import '../flutter_reaction_button.dart';

class ReactionsBoxItem extends StatefulWidget {
  final Function(Reaction) onReactionClick;

  final Reaction reaction;

  const ReactionsBoxItem({
    Key key,
    @required this.reaction,
    @required this.onReactionClick,
  }) : super(key: key);

  @override
  _ReactionsBoxItemState createState() => _ReactionsBoxItemState();
}

class _ReactionsBoxItemState extends State<ReactionsBoxItem>
    with TickerProviderStateMixin {
  AnimationController _scaleController;

  Animation<double> _scaleAnimation;

  double _scale = 1;

  @override
  void initState() {
    super.initState();

    // Start animation
    _scaleController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 100));

    final Tween<double> startTween = Tween(begin: 1, end: 1.3);
    _scaleAnimation = startTween.animate(_scaleController)
      ..addListener(() {
        setState(() {
          _scale = _scaleAnimation.value;
        });
      });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: _scale,
      child: GestureDetector(
        onTap: () {
          _scaleController.reverse();
          widget.onReactionClick(widget.reaction);
        },
        onPanDown: (details) {
          _scaleController.forward();
        },
        onPanEnd: (details) {
          _scaleController.reverse();
        },
        child: widget.reaction.previewIcon,
      ),
    );
  }
}
