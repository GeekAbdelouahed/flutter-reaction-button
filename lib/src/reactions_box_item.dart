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
  static const double _MIN_SCALE = .8, _NORMAL_SCALE = 1, _MAX_SCALE = 1.2;
  final GlobalKey _widgetKey = GlobalKey();

  late AnimationController _scaleController;

  late Tween<double> _startTween;

  late Animation<double> _scaleAnimation;

  double _scale = 1;

  double? _height;
  double? _width;

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

    _startTween = Tween(begin: _NORMAL_SCALE, end: _MAX_SCALE);
    _scaleAnimation = _startTween.animate(_scaleController)
      ..addListener(() {
        setState(() {
          _scale = _scaleAnimation.value;
        });

        if (_scale == _MAX_SCALE && _overlayEntry == null) {
          _showTitle();
        } else if (_scale <= _NORMAL_SCALE) {
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
              if (_height == null && _width == null) {
                _height = widgetSize.height;
                _width = widgetSize.width;
              }
              final deltaOffset = currentOffset - _widgetKey.widgetOffset;
              final isHovered =
                  _width! > deltaOffset.distance && widget.reaction!.enabled;
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
                  _startTween.begin = _NORMAL_SCALE;
                  WidgetsBinding.instance!.addPostFrameCallback((_) {
                    _scaleController.reset();
                  });
                } else {
                  _startTween.begin = _MIN_SCALE;
                  _scaleController.reverse();
                }
              }
            } else {
              _startTween.begin = _NORMAL_SCALE;
              _scaleController.reverse();
            }
            return Transform.scale(
              scale: _scale,
              child: AnimatedContainer(
                height: _height != null ? _height! * _scale : null,
                width: _width != null ? _width! * _scale : null,
                duration: const Duration(milliseconds: 250),
                child: FittedBox(
                  child: InkWell(
                    onTap: _onSelected,
                    splashColor: widget.splashColor,
                    highlightColor: widget.highlightColor,
                    child: widget.reaction!.previewIcon,
                  ),
                ),
              ),
            );
          }),
    );
  }
}
