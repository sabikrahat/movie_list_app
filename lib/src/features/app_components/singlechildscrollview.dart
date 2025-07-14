import 'package:flutter/material.dart';

class KSingleChildScrollView extends StatelessWidget {
  const KSingleChildScrollView({
    super.key,
    this.child,
    this.scrollDirection = Axis.vertical,
    this.physics,
  });

  final Widget? child;
  final Axis scrollDirection;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: SingleChildScrollView(
        scrollDirection: scrollDirection,
        physics: physics,
        child: child,
      ),
    );
  }
}
