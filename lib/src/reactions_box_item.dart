import 'dart:async';

import 'package:flutter/material.dart';

import 'extensions.dart';
import 'reaction.dart';
import 'drag.dart';

class ReactionsBoxItem extends StatefulWidget {
  final Function(Reaction?) onReactionClick;

  final Reaction? reaction;

  final Color? highlightColor;

  final Color? splashColor;

  final Stream<DragData> dragStream;

  const ReactionsBoxItem({
    Key? key,
    required this.reaction,
    required this.onReactionClick,
    this.highlightColor,
    this.splashColor,
    required this.dragStream,
  }) : super(key: key);

  @override
  _ReactionsBoxItemState createState() => _ReactionsBoxItemState();
}

class _ReactionsBoxItemState extends State<ReactionsBoxItem>
    with TickerProviderStateMixin {
  final GlobalKey _widgetKey = GlobalKey();

  late AnimationController _scaleController;

  late Tween<double> _startTween;

  late Animation<double> _scaleAnimation;

  double _scale = 1;

  OverlayEntry? _overlayEntry;

  void _onSelected() {
    _hideTitle();
    _scaleController.reverse();
    widget.onReactionClick(widget.reaction);
  }

  OverlayEntry _createTitle() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (_) => Positioned(
        left: offset.dx,
        top: offset.dy - size.height * .5,
        child: Material(
          elevation: 0,
          color: Colors.transparent,
          child: widget.reaction!.title ?? const SizedBox(),
        ),
      ),
    );
  }

  void _showTitle() {
    _overlayEntry = _createTitle();
    Overlay.of(context)!.insert(_overlayEntry!);
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
        AnimationController(vsync: this, duration: Duration(milliseconds: 250));

    _startTween = Tween(begin: 1, end: 1.5);
    _scaleAnimation = _startTween.animate(_scaleController)
      ..addListener(() {
        setState(() {
          _scale = _scaleAnimation.value;
        });

        if (_scale == 1.5 && _overlayEntry == null) {
          _showTitle();
        } else if (_scale <= 1) {
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
  Widget build(BuildContext context) {
    return IgnorePointer(
      key: _widgetKey,
      ignoring: !widget.reaction!.enabled,
      child: StreamBuilder<DragData>(
          stream: widget.dragStream,
          builder: (_, snapshot) {
            if (snapshot.hasData) {
              final dragData = snapshot.data;
              final Offset currentOffset = dragData?.offset ?? Offset.zero;
              final widgetSize = _widgetKey.widgetSize;
              final deltaOffset = currentOffset - _widgetKey.widgetOffset;
              final isHovered = widgetSize.width > deltaOffset.distance &&
                  widget.reaction!.enabled;
              if (isHovered) {
                bool isSelected = snapshot.data?.isDragEnd ?? false;
                if (isSelected) {
                  _onSelected();
                } else {
                  _scaleController.forward();
                }
              } else {
                bool isDraggingEnded = dragData?.isDragEnd ?? false;
                if (isDraggingEnded) {
                  _startTween.begin = 1;
                  WidgetsBinding.instance!.addPostFrameCallback((_) {
                    _scaleController.reset();
                  });
                } else {
                  _startTween.begin = .75;
                  _scaleController.reverse();
                }
              }
            } else {
              _startTween.begin = 1;
              _scaleController.reverse();
            }
            return Transform.scale(
              scale: _scale,
              child: InkWell(
                onTap: _onSelected,
                splashColor: widget.splashColor,
                highlightColor: widget.highlightColor,
                child: widget.reaction!.previewIcon,
              ),
            );
          }),
    );
  }
}
