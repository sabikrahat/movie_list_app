import 'package:flutter/material.dart';

import '../../../../core/shared/shimmer/app_shimmer.dart';
import '../../../../core/utils/extensions/extensions.dart';
import '../../../app_components/page_padding.dart';

class MovieShimmerLoader extends StatelessWidget {
  const MovieShimmerLoader({super.key, this.itemCount = 8});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return PagePadding(
      child: ListView.builder(
        itemCount: itemCount,
        itemBuilder: (context, index) => const MovieCardShimmer(),
      ),
    );
  }
}

class MovieCardShimmer extends StatelessWidget {
  const MovieCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: context.theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: context.theme.shadowColor.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: context.theme.dividerColor.withValues(alpha: 0.1), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with title and action buttons
            Row(
              children: [
                Expanded(
                  child: AppShimmers.container(
                    context,
                    height: 20,
                    width: context.width * 0.6,
                    radius: 6,
                  ),
                ),
                const SizedBox(width: 8),
                AppShimmers.container(context, height: 25, width: 25, radius: 20),
                const SizedBox(width: 4),
                AppShimmers.container(context, height: 25, width: 25, radius: 20),
                const SizedBox(width: 4),
                AppShimmers.container(context, height: 25, width: 25, radius: 20),
              ],
            ),
            const SizedBox(height: 12),
            // Description lines
            AppShimmers.container(context, height: 16, width: context.width * 0.9, radius: 4),
            const SizedBox(height: 6),
            AppShimmers.container(context, height: 16, width: context.width * 0.7, radius: 4),
            const SizedBox(height: 12),
            // Footer row
            Row(
              children: [
                AppShimmers.container(context, height: 14, width: 14, radius: 7),
                const SizedBox(width: 4),
                Expanded(
                  child: AppShimmers.container(
                    context,
                    height: 12,
                    width: context.width * 0.4,
                    radius: 4,
                  ),
                ),
                const SizedBox(width: 4),
                AppShimmers.container(context, height: 16, width: 80, radius: 12),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
