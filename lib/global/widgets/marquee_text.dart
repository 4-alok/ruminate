import 'package:flutter/material.dart';

class MarqueeText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final ValueNotifier<bool> hover;

  const MarqueeText({
    Key? key,
    required this.text,
    this.style,
    required this.hover,
  }) : super(key: key);

  @override
  State<MarqueeText> createState() => _MarqueeTextState();
}

class _MarqueeTextState extends State<MarqueeText> {
  late ScrollController scrollController;
  bool animating = false;

  @override
  void initState() {
    scrollController = ScrollController();
    widget.hover.addListener(() async => animate);
    super.initState();
  }

  Future<void> get animate async {
    if (scrollController.hasClients) {
      if (widget.hover.value && !animating) {
        animating = true;
        await scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 50 * widget.text.length),
          curve: Curves.easeInOut,
        );
        await Future.delayed(const Duration(milliseconds: 1200));
        await scrollController.animateTo(
          0.0,
          duration: const Duration(milliseconds: 1200),
          curve: Curves.easeOut,
        );
        animating = false;
      }
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: scrollController,
        child: Text(
          maxLines: 1,
          overflow: TextOverflow.clip,
          widget.text,
          style: widget.style,
        ),
      );
}
