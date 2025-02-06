import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class AnimatedWidgets extends StatelessWidget {
  final Widget child;
  final double verticalOffset;
  final double horizontalOffset;
  final int durationMilli;
  final int postion;

  const AnimatedWidgets({
    super.key,
    required this.child,
    this.verticalOffset = 50,
    this.horizontalOffset = 0,
    this.durationMilli = 500,
    this.postion = 2,
  });

  @override
  Widget build(BuildContext context) {
    return AnimationConfiguration.staggeredList(
      position: postion,
      duration: Duration(milliseconds: durationMilli),
      child: SlideAnimation(
        curve: Curves.easeInOut,
        horizontalOffset: horizontalOffset,
        verticalOffset: verticalOffset,
        child: FadeInAnimation(
          child: child,
        ),
      ),
    );
  }
}

class ListAnimator extends StatefulWidget {
  final List<Widget>? data;
  final int? durationMilli;
  final double? verticalOffset;
  final double? horizontalOffset;
  final ScrollController? controller;
  final dynamic direction;
  final dynamic addPadding;
  final bool scroll;
  final dynamic customPadding;
  final Stream<int>? scrollControllerStream;

  const ListAnimator({
    this.controller,
    super.key,
    this.data,
    this.durationMilli,
    this.verticalOffset,
    this.horizontalOffset,
    this.direction,
    this.addPadding = true,
    this.customPadding,
    this.scrollControllerStream,
    this.scroll = true,
  });

  @override
  State<ListAnimator> createState() => _ListAnimatorState();
}

class _ListAnimatorState extends State<ListAnimator> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: widget.scrollControllerStream,
      builder: (context, snapshot) {
        return AnimationLimiter(
          child: ListView.builder(
            controller: widget.controller,
            padding: widget.customPadding ??
                EdgeInsets.only(top: widget.addPadding ? 0 : 0),
            physics: widget.scroll
                ? const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics())
                : const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: widget.direction ?? Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: Duration(milliseconds: widget.durationMilli ?? 375),
                child: SlideAnimation(
                  verticalOffset: widget.verticalOffset ?? 0.0,
                  child: FadeInAnimation(child: widget.data![index]),
                ),
              );
            },
            itemCount: widget.data!.length,
          ),
        );
      },
    );
  }
}
