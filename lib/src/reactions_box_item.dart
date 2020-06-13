import 'package:flutter/material.dart';
import '../flutter_reaction_button.dart';

class ReactionsBoxItem extends StatefulWidget {
  final Function(Reaction) onReactionClick;

  final Reaction reaction;

  final Color highlightColor;

  final Color splashColor;

  const ReactionsBoxItem({
    Key key,
    @required this.reaction,
    @required this.onReactionClick,
    this.highlightColor,
    this.splashColor,
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
  Widget build(BuildContext context) => Transform.scale(
        scale: _scale,
        child: InkWell(
          onTap: () {
            _scaleController.reverse();
            widget.onReactionClick(widget.reaction);
          },
          onTapDown: (_) {
            _scaleController.forward();
          },
          onTapCancel: () {
            _scaleController.reverse();
          },
          splashColor: widget.splashColor,
          highlightColor: widget.highlightColor,
          child: widget.reaction.previewIcon,
        ),
      );
}
