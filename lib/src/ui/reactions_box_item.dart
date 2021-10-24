import 'dart:async';

import 'package:flutter/material.dart';

import '../models/drag.dart';
import '../models/reaction.dart';
import '../utils/extensions.dart';
import 'title.dart';

class ReactionsBoxItem extends StatefulWidget {
  // TODO for test
  final int index;

  final Function(Reaction?) onReactionClick;

  final Reaction reaction;

  final int itemsCount;

  final Stream<DragData> dragStream;

  final Color? highlightColor;

  final Color? splashColor;

  const ReactionsBoxItem({
    Key? key,
    required this.index,
    required this.reaction,
    required this.onReactionClick,
    required this.itemsCount,
    required this.dragStream,
    this.highlightColor,
    this.splashColor,
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

  double _minScale = 1, _normalScale = 1, _maxScale = 1.2;

  double _scale = 1;

  double? _width;

  OverlayEntry? _overlayEntry;

  void _onSelected() {
    _hideTitle();
    _scaleController.reverse();
    widget.onReactionClick.call(widget.reaction);
  }

  void _showTitle() {
    final size = _widgetKey.widgetSize;
    final offset = _widgetKey.widgetOffset;

    _overlayEntry = OverlayEntry(
      builder: (_) => TitleWidget(
        title: widget.reaction.title,
        parentSize: size,
        parentOffset: offset,
      ),
    );

    Overlay.of(context)?.insert(_overlayEntry!);
  }

  void _hideTitle() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void initState() {
    super.initState();

    // Calculating how much we should scale down unselected items
    _minScale = 1 - (.2 / widget.itemsCount);

    // Start animation
    _scaleController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 250));

    _startTween = Tween(begin: _normalScale, end: _maxScale);

    _scaleAnimation = _startTween.animate(_scaleController)
      ..addListener(() {
        _scale = _scaleAnimation.value;

        if (_scale == _maxScale && _overlayEntry == null) {
          _showTitle();
        } else if (_scale <= _normalScale) {
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
      ignoring: !widget.reaction.enabled,
      child: StreamBuilder<DragData>(
          stream: widget.dragStream,
          builder: (_, snapshot) {
            if (snapshot.hasData) {
              final dragData = snapshot.data;
              final Offset currentOffset = dragData?.offset ?? Offset.zero;
              final widgetSize = _widgetKey.widgetSize;
              if (_width == null) {
                _width = widgetSize.width;
              }
              final deltaOffset = currentOffset - _widgetKey.widgetOffset;
              final isHovered =
                  _width! > deltaOffset.distance && widget.reaction.enabled;
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
                  _startTween.begin = _normalScale;
                  WidgetsBinding.instance!.addPostFrameCallback((_) {
                    _scaleController.reset();
                  });
                } else {
                  _startTween.begin = _minScale;
                  _scaleController.reverse();
                }
              }
            } else {
              _startTween.begin = _normalScale;
              _scaleController.reverse();
            }
            return AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (_, snapshot) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: AnimatedContainer(
                      width: _width != null ? _width! * _scale : null,
                      duration: const Duration(milliseconds: 250),
                      child: FittedBox(
                        child: InkWell(
                          onTap: _onSelected,
                          splashColor: widget.splashColor,
                          highlightColor: widget.highlightColor,
                          child: widget.reaction.previewIcon,
                        ),
                      ),
                    ),
                  );
                });
          }),
    );
  }
}
