import 'package:flutter/material.dart';

import 'reaction.dart';

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

  OverlayEntry _overlayEntry;

  OverlayEntry _createTitle() {
    RenderBox renderBox = context.findRenderObject();
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (_) => Positioned(
        left: offset.dx,
        top: offset.dy - size.height * .5,
        child: Material(
          elevation: 0,
          color: Colors.transparent,
          child: widget.reaction.title ?? const SizedBox(),
        ),
      ),
    );
  }

  void _showTitle() {
    _overlayEntry = _createTitle();
    Overlay.of(context).insert(_overlayEntry);
  }

  void _hideTitle() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

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

        if (_scale == 1.3 && _overlayEntry == null) {
          _showTitle();
        } else if (_scale == 1) {
          _hideTitle();
        }
      });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => IgnorePointer(
        ignoring: !widget.reaction.enabled,
        child: Transform.scale(
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
        ),
      );
}
