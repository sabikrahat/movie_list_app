import 'package:flutter/material.dart';

import '../../core/config/size.dart';

class PagePadding extends StatelessWidget {
  final Widget child;
  final bool top;
  final bool bottom;
  final bool left;
  final bool right;
  final double? padding;

  const PagePadding({
    super.key,
    required this.child,
    this.top = true,
    this.bottom = true,
    this.left = true,
    this.right = true,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          left ? padding ?? defaultPadding / 3 : 0,
          top ? padding ?? defaultPadding / 3 : 0,
          right ? padding ?? defaultPadding / 3 : 0,
          bottom ? padding ?? defaultPadding / 3 : 0,
        ),
        child: child,
      ),
    );
  }
}
