import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../utils/extensions/extensions.dart';

class AppShimmers {
  AppShimmers._();

  static Widget circle(
    BuildContext context, {
    Color? baseColor,
    Color? highlightColor,
    double? radius,
  }) => Shimmer.fromColors(
    baseColor: baseColor ?? context.theme.highlightColor.withValues(alpha: 0.2),
    highlightColor: highlightColor ?? context.theme.highlightColor.withValues(alpha: 0.4),
    child: CircleAvatar(radius: radius),
  );
  static Widget container(
    BuildContext context, {
    double? height,
    double? width,
    EdgeInsets? margin,
    Color? baseColor,
    Color? highlightColor,
    double radius = 10,
    String? message,
  }) {
    final shimmer = Shimmer.fromColors(
      baseColor: baseColor ?? context.theme.highlightColor.withValues(alpha: 0.2),
      highlightColor: highlightColor ?? context.theme.highlightColor.withValues(alpha: 0.4),
      child: Container(
        height: height,
        width: width,
        margin: margin,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );

    if (message != null) {
      return Stack(
        alignment: Alignment.center,
        children: [
          shimmer,
          Text(
            message,
            style: context.text.bodyMedium?.copyWith(color: Colors.grey.shade500),
          ),
        ],
      );
    } else {
      return shimmer;
    }
  }
}
