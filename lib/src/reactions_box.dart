import 'package:flutter/material.dart';
import 'reactions_position.dart';
import './reaction.dart';
import './utils.dart';

class ReactionsBox extends StatefulWidget {
  final Offset buttonOffset;

  final Size buttonSize;

  final List<Reaction> reactions;

  final position;

  final Color color;

  final double elevation;

  final double radius;

  final Duration duration;

  const ReactionsBox({
    @required this.buttonOffset,
    @required this.buttonSize,
    @required this.reactions,
    @required this.position,
    this.color = Colors.white,
    this.elevation = 5,
    this.radius = 50,
    this.duration = const Duration(milliseconds: 200),
  })  : assert(buttonOffset != null),
        assert(buttonSize != null),
        assert(reactions != null),
        assert(position != null);

  @override
  _ReactionsBoxState createState() => _ReactionsBoxState();
}

class _ReactionsBoxState extends State<ReactionsBox>
    with TickerProviderStateMixin {
  AnimationController _startController, _endController;

  Animation<double> _startAnimation, _endAnimation;

  double _scale = 0;

  @override
  void initState() {
    super.initState();

    // Start animation
    _startController =
        AnimationController(vsync: this, duration: widget.duration);

    final Tween<double> startTween = Tween(begin: 0, end: 1);
    _startAnimation = startTween.animate(_startController)
      ..addListener(() {
        setState(() {
          _scale = _startAnimation.value;
        });
      });

    // End animation
    _endController =
        AnimationController(vsync: this, duration: widget.duration);
    final Tween<double> endTween = Tween(begin: 1, end: 0);
    _endAnimation = endTween.animate(_endController)
      ..addListener(() {
        setState(() {
          _scale = _endAnimation.value;
        });
      });

    _startController.forward();
  }

  @override
  void dispose() {
    _startController.dispose();
    _endController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Hide box when clicking out
      onTap: () => _hideBox(context),
      child: Container(
        height: double.infinity,
        color: Colors.transparent,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
              top: _getPosition(context),
              child: GestureDetector(
                child: Transform.scale(
                  scale: _scale,
                  child: Card(
                    color: widget.color,
                    elevation: widget.elevation,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(widget.radius)),
                    child: Wrap(
                      children: widget.reactions
                          .map((reaction) => InkWell(
                              onTap: () => _hideBox(context, reaction),
                              child: reaction.previewIcon))
                          .toList(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _hideBox(BuildContext context, [Reaction reaction]) {
    _endController.addStatusListener((status) {
      if (status == AnimationStatus.completed)
        Navigator.of(context).pop(reaction);
    });
    _endController.forward();
  }

  double _getPosition(BuildContext context) {
    if (_getTopPosition() - widget.buttonSize.height * 2 < 0)
      return _getBottomPosition();
    if (_getBottomPosition() + widget.buttonSize.height * 2 >
        getScreenSize(context).height) return _getTopPosition();
    return widget.position == Position.TOP
        ? _getTopPosition()
        : _getBottomPosition();
  }

  double _getTopPosition() =>
      widget.buttonOffset.dy - widget.buttonSize.height * 3.3;

  double _getBottomPosition() =>
      widget.buttonOffset.dy + widget.buttonSize.height;
}
