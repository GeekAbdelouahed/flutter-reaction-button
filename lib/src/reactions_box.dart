import 'package:flutter/material.dart';

import 'reactions_box_item.dart';
import 'reactions_position.dart';
import 'reaction.dart';
import 'extensions.dart';

class ReactionsBox extends StatefulWidget {
  final Offset anchorOffset;

  final Size anchorSize;

  final List<Reaction> reactions;

  final Position position;

  final Color color;

  final double elevation;

  final double radius;

  final Duration duration;

  final Color highlightColor;

  final Color splashColor;

  final AlignmentGeometry alignment;

  final EdgeInsets boxPadding;

  final double boxItemsSpacing;

  const ReactionsBox({
    @required this.anchorOffset,
    @required this.anchorSize,
    @required this.reactions,
    @required this.position,
    this.color = Colors.white,
    this.elevation = 5,
    this.radius = 50,
    this.duration = const Duration(milliseconds: 200),
    this.highlightColor,
    this.splashColor,
    this.alignment = Alignment.centerLeft,
    this.boxPadding = const EdgeInsets.all(0),
    this.boxItemsSpacing = 0,
  })  : assert(anchorOffset != null),
        assert(anchorSize != null),
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
  Widget build(BuildContext context) => Stack(
        alignment: widget.alignment,
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTapDown: (_) => _scaleController.reverse(),
              onVerticalDragUpdate: (_) => _scaleController.reverse(),
              onHorizontalDragUpdate: (_) => _scaleController.reverse(),
            ),
          ),
          Positioned(
            top: _getYPosition(context),
            left: _getXPosition(context),
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
        ],
      );

  double _getYPosition(BuildContext context) => (_getTopPosition() - 30 < 0)
      ? _getBottomPosition()
      : (_getBottomPosition() + 30 > context.screenSize.height)
          ? _getTopPosition()
          : widget.position == Position.TOP
              ? _getTopPosition()
              : _getBottomPosition();

  double _getXPosition(BuildContext context) => (_getLeftPosition() < 0)
      ? _getRightPosition()
      : (_getRightPosition() + 150 > context.screenSize.width)
          ? _getLeftPosition()
          : widget.position == Position.LEFT
              ? _getLeftPosition()
              : _getRightPosition();

  double _getTopPosition() => widget.anchorOffset.dy - 10;

  double _getBottomPosition() =>
      widget.anchorOffset.dy + widget.anchorSize.height / 2;

  double _getRightPosition() =>
      widget.anchorOffset.dx + widget.anchorSize.width + 8;

  double _getLeftPosition() => widget.anchorOffset.dx - 150;
}
