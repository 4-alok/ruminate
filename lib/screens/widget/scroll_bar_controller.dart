import 'dart:async';
import 'package:flutter/material.dart';

class ScrollBarControl extends StatefulWidget {
  const ScrollBarControl({
    Key key,
    @required this.child,
    this.controller,
    this.isAlwaysShown = false,
  })  : assert(
          !isAlwaysShown || controller != null,
        ),
        super(key: key);

  final Widget child;

  final ScrollController controller;
  final bool isAlwaysShown;

  @override
  _ScrollbarState createState() => _ScrollbarState();
}

class _ScrollbarState extends State<ScrollBarControl>
    with TickerProviderStateMixin {
  ScrollbarPainter _materialPainter;
  TextDirection _textDirection;
  AnimationController _fadeoutAnimationController;
  Animation<double> _fadeoutOpacityAnimation;
  Timer _fadeoutTimer;

  @override
  void initState() {
    super.initState();
    _fadeoutAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeoutOpacityAnimation = CurvedAnimation(
      parent: _fadeoutAnimationController,
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    assert((() {
      return true;
    })());
    _textDirection = Directionality.of(context);
    _materialPainter = ScrollbarPainter(
      color: Colors.blue,
      textDirection: _textDirection,
      thickness: 13,
      minLength: 80,
      fadeoutOpacityAnimation: _fadeoutOpacityAnimation,
      padding: MediaQuery.of(context).padding,
    );
    _triggerScrollbar();
  }

  @override
  void didUpdateWidget(ScrollBarControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isAlwaysShown != oldWidget.isAlwaysShown) {
      if (widget.isAlwaysShown == false) {
        _fadeoutAnimationController.reverse();
      } else {
        _triggerScrollbar();
        _fadeoutAnimationController.animateTo(1.0);
      }
    }
  }

  void _triggerScrollbar() {
    WidgetsBinding.instance.addPostFrameCallback((Duration duration) {
      if (widget.isAlwaysShown) {
        _fadeoutTimer?.cancel();
        widget.controller.position.didUpdateScrollPositionBy(0);
      }
    });
  }

  @override
  void dispose() {
    _fadeoutAnimationController.dispose();
    _fadeoutTimer?.cancel();
    _materialPainter?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification notification) {
          final ScrollMetrics metrics = notification.metrics;
          if (metrics.maxScrollExtent <= metrics.minScrollExtent) {
            return false;
          }

          if ((notification is ScrollUpdateNotification ||
              notification is OverscrollNotification)) {
            if (_fadeoutAnimationController.status != AnimationStatus.forward) {
              _fadeoutAnimationController.forward();
            }

            _materialPainter.update(
              notification.metrics,
              notification.metrics.axisDirection,
            );
            if (!widget.isAlwaysShown) {
              _fadeoutTimer?.cancel();
              _fadeoutTimer = Timer(const Duration(milliseconds: 800), () {
                _fadeoutAnimationController.reverse();
                _fadeoutTimer = null;
              });
            }
          }
          return false;
        },
        child: GestureDetector(
          onVerticalDragUpdate: (details) {
            final total = widget.controller.position.maxScrollExtent;

            if (widget.controller.position.extentBefore > 0 ||
                widget.controller.position.extentAfter > 0) {
              if (details.localPosition.dy < 0)
                return widget.controller.jumpTo(0);

              final offSet = total /
                  widget.controller.position.extentInside *
                  details.localPosition.dy;

              if (offSet > total) return widget.controller.jumpTo(total);

              widget.controller.jumpTo(offSet);
            }
          },
          child: RepaintBoundary(
              child: CustomPaint(
                  foregroundPainter: _materialPainter,
                  child: RepaintBoundary(child: widget.child))),
        ));
  }
}
