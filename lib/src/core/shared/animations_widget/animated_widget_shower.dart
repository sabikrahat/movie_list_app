import 'package:flutter/material.dart';

import '../../config/size.dart';
import '../../utils/extensions/extensions.dart';

class AnimatedWidgetShower extends StatelessWidget {
  const AnimatedWidgetShower({
    super.key,
    required this.child,
    required this.size,
    this.padding = 6.0,
    this.color,
    this.shape,
  });

  final Widget child;
  final double size;
  final double padding;
  final Color? color;
  final ShapeBorder? shape;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: shape ?? defaultRoundedRectangleBorder,
      color: color ?? context.theme.primaryColor.withValues(alpha: 0.2),
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: SizedBox(
          height: size,
          width: size,
          child: TweenAnimationBuilder(
            curve: Curves.easeOut,
            duration: kAnimationDuration(0.4),
            tween: Tween<double>(begin: 0, end: size),
            builder: (_, double x, _) {
              return Center(
                child: SizedBox(height: x, width: x, child: child),
              );
            },
          ),
        ),
      ),
    );
  }
}
