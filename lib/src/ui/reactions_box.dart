import 'dart:async';

import 'package:flutter/material.dart';

import '../models/drag.dart';
import '../models/reaction.dart';
import '../utils/extensions.dart';
import '../utils/reactions_position.dart';
import 'reactions_box_item.dart';
import 'widget_size_render_object.dart';

class ReactionsBox extends StatefulWidget {
  final Offset buttonOffset;

  final Size buttonSize;

  final List<Reaction?> reactions;

  final Position position;

  final Color color;

  final double elevation;

  final double radius;

  final Duration duration;

  final EdgeInsets boxPadding;

  final double itemScale;

  final Duration? itemScaleDuration;

  const ReactionsBox({
    Key? key,
    required this.buttonOffset,
    required this.buttonSize,
    required this.reactions,
    required this.position,
    this.color = Colors.white,
    this.elevation = 5,
    this.radius = 50,
    this.duration = const Duration(milliseconds: 200),
    this.boxPadding = const EdgeInsets.all(0),
    this.itemScale = .3,
    this.itemScaleDuration,
  })  : assert(itemScale > 0.0 && itemScale < 1),
        super(key: key);

  @override
  _ReactionsBoxState createState() => _ReactionsBoxState();
}

class _ReactionsBoxState extends State<ReactionsBox> with TickerProviderStateMixin {
  final StreamController<DragData?> _dragStreamController = StreamController<DragData?>();

  late Stream<DragData?> _dragStream;

  late AnimationController _boxSizeController;

  late Animation<Size?> _boxSizeAnimation;

  late Tween<Size?> _boxSizeTween;

  late AnimationController _scaleController;

  late Animation<double> _scaleAnimation;

  late double _itemScale;

  Reaction? _selectedReaction;

  DragData? _dragData;

  double? _getBoxHeight() {
    if (_boxSizeAnimation.value == null) return null;

    bool anyItemHasTitle = widget.reactions.any(
      (item) => item?.title != null,
    );

    if (anyItemHasTitle) return _boxSizeAnimation.value!.height * .75;

    return _boxSizeAnimation.value!.height;
  }

  @override
  void initState() {
    super.initState();

    // Calculating how much we should scale up when item hovered
    _itemScale = 1 + widget.itemScale;

    _boxSizeController = AnimationController(vsync: this, duration: widget.duration);
    _boxSizeTween = Tween();
    _boxSizeAnimation = _boxSizeTween.animate(_boxSizeController);

    _scaleController = AnimationController(vsync: this, duration: widget.duration);
    final Tween<double> scaleTween = Tween(begin: 0, end: 1);
    _scaleAnimation = scaleTween.animate(_scaleController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.reverse) Navigator.of(context).pop(_selectedReaction);
      });

    _scaleController
      ..forward()
      ..addListener(() {
        setState(() {});
      });

    _dragStream = _dragStreamController.stream.asBroadcastStream();
  }

  @override
  void dispose() {
    _boxSizeController.dispose();
    _scaleController.dispose();
    _dragStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double top = _getVerticalPosition();

    return Material(
      elevation: 0,
      color: Colors.transparent,
      child: Stack(
        children: [
          Positioned.fill(
            child: Listener(
              onPointerDown: (_) {
                _scaleController.reverse();
              },
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
          PositionedDirectional(
            top: top,
            start: _getHorizontalPosition(),
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: AnimatedBuilder(
                animation: _boxSizeAnimation,
                child: _buildItems(),
                builder: (_, child) {
                  return SizedBox(
                    height: _boxSizeAnimation.value?.height,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Material(
                          color: widget.color,
                          elevation: widget.elevation,
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(widget.radius),
                          ),
                          child: SizedBox(
                            height: _getBoxHeight(),
                            width: _boxSizeAnimation.value?.width,
                          ),
                        ),
                        child!,
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItems() {
    return WidgetSizeOffsetWrapper(
      onSizeChange: (Size size) {
        _boxSizeTween
          ..begin = size
          ..end = size;
        if (_boxSizeController.isCompleted)
          _boxSizeController.reverse();
        else
          _boxSizeController.forward();
      },
      child: Padding(
        padding: widget.boxPadding,
        child: Listener(
          onPointerDown: (point) {
            _dragData = DragData(offset: point.position);
            _dragStreamController.add(_dragData);
          },
          onPointerMove: (point) {
            _dragData = DragData(offset: point.position);
            _dragStreamController.add(_dragData);
          },
          onPointerUp: (point) {
            _dragData = _dragData?.copyWith(isDragEnd: true);
            _dragStreamController.add(_dragData);
          },
          onPointerCancel: (point) {
            _dragData = _dragData?.copyWith(isDragEnd: true);
            _dragStreamController.add(_dragData);
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: widget.reactions.map(
              (reaction) {
                return ReactionsBoxItem(
                  onReactionSelected: (reaction) {
                    _selectedReaction = reaction;
                    _scaleController.reverse();
                  },
                  scale: _itemScale,
                  scaleDuration: widget.itemScaleDuration,
                  reaction: reaction!,
                  dragStream: _dragStream,
                );
              },
            ).toList(),
          ),
        ),
      ),
    );
  }

  double _getHorizontalPosition() {
    final buttonX = widget.buttonOffset.dx;
    final buttonRadius = (widget.buttonSize.width / 2);
    final screenWidth = MediaQuery.of(context).size.width;

    if (buttonX + (_boxSizeAnimation.value?.width ?? 0) < screenWidth)
      return buttonX - buttonRadius;

    final value = buttonX + buttonRadius - (_boxSizeAnimation.value?.width ?? 0);

    //add this below code.
    if (value.isNegative) {
      return 20; // this is 20 horizontal width is fix you can play with it as you want.
    }
    return buttonX + buttonRadius - (_boxSizeAnimation.value?.width ?? 0);
  }

  double _getVerticalPosition() {
    // check if TOP space not enough for the box
    if (_getTopPosition() - widget.buttonSize.height * 4.5 < 0) return _getBottomPosition();

    // check if BOTTOM space not enough for the box
    if (_getBottomPosition() + (widget.buttonSize.height * 5.5) > context.screenSize.height)
      return _getTopPosition();

    if (widget.position == Position.TOP) return _getTopPosition();

    return _getBottomPosition();
  }

  double _getTopPosition() {
    return widget.buttonOffset.dy - (widget.buttonSize.height * 5);
  }

  double _getBottomPosition() {
    return widget.buttonOffset.dy;
  }
}
