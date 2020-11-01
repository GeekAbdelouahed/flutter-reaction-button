import 'package:flutter/material.dart';

import 'reactions_box_item.dart';
import 'reactions_position.dart';
import 'reaction.dart';
import 'extensions.dart';

class ReactionsBox extends StatefulWidget {
  final Offset buttonOffset;

  final Size buttonSize;

  final List<Reaction> reactions;

  final Position position;

  final Color color;

  final double elevation;

  final double radius;

  final Duration duration;

  final Color highlightColor;

  final Color splashColor;

  final Alignment alignment;

  final EdgeInsets boxPadding;

  final double boxItemsSpacing;

  const ReactionsBox({
    @required this.buttonOffset,
    @required this.buttonSize,
    @required this.reactions,
    @required this.position,
    this.color = Colors.white,
    this.elevation = 5,
    this.radius = 50,
    this.duration = const Duration(milliseconds: 200),
    this.highlightColor,
    this.splashColor,
    this.alignment = Alignment.center,
    this.boxPadding = const EdgeInsets.all(0),
    this.boxItemsSpacing = 0,
  })  : assert(buttonOffset != null),
        assert(buttonSize != null),
        assert(reactions != null),
        assert(position != null);

  @override
  _ReactionsBoxState createState() => _ReactionsBoxState();
}

class _ReactionsBoxState extends State<ReactionsBox>
    with TickerProviderStateMixin {
  AnimationController _scaleController;

  Animation<double> _scaleAnimation;

  double _scale = 0;

  Reaction _selectedReaction;

  @override
  void initState() {
    super.initState();

    _scaleController =
        AnimationController(vsync: this, duration: widget.duration);

    final Tween<double> startTween = Tween(begin: 0, end: 1);
    _scaleAnimation = startTween.animate(_scaleController)
      ..addListener(() {
        setState(() {
          _scale = _scaleAnimation.value;
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.reverse)
          Navigator.of(context).pop(_selectedReaction);
      });

    _scaleController.forward();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        // Hide box when clicking out
        onTap: () => _scaleController.reverse(),
        child: Container(
          height: double.infinity,
          color: Colors.transparent,
          child: Stack(
            alignment: widget.alignment,
            children: [
              Positioned(
                top: _getPosition(context),
                child: GestureDetector(
                  child: Transform.scale(
                    scale: _scale,
                    child: Card(
                      color: widget.color,
                      elevation: widget.elevation,
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(widget.radius),
                      ),
                      child: Padding(
                        padding: widget.boxPadding,
                        child: Wrap(
                          spacing: widget.boxItemsSpacing,
                          children: widget.reactions
                              .map(
                                (reaction) => ReactionsBoxItem(
                                  onReactionClick: (reaction) {
                                    _selectedReaction = reaction;
                                    _scaleController.reverse();
                                  },
                                  splashColor: widget.splashColor,
                                  highlightColor: widget.highlightColor,
                                  reaction: reaction,
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  double _getPosition(BuildContext context) =>
      (_getTopPosition() - widget.buttonSize.height * 2 < 0)
          ? _getBottomPosition()
          : (_getBottomPosition() + widget.buttonSize.height * 2 >
                  context.screenSize.height)
              ? _getTopPosition()
              : widget.position == Position.TOP
                  ? _getTopPosition()
                  : _getBottomPosition();

  double _getTopPosition() =>
      widget.buttonOffset.dy - widget.buttonSize.height * 3.3;

  double _getBottomPosition() =>
      widget.buttonOffset.dy + widget.buttonSize.height;
}
