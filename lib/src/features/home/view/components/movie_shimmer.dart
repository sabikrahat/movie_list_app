import 'package:flutter/material.dart';

import '../../../../core/config/size.dart';
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
    return Card(
      margin: const EdgeInsets.only(bottom: defaultPadding),
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and favorite button row
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
                const SizedBox(width: defaultPadding),
                AppShimmers.container(context, height: 24, width: 24, radius: 12),
              ],
            ),
            const SizedBox(height: defaultPadding / 2),
            // Description lines
            AppShimmers.container(context, height: 16, width: context.width * 0.9, radius: 4),
            const SizedBox(height: 6),
            AppShimmers.container(context, height: 16, width: context.width * 0.7, radius: 4),
            const SizedBox(height: defaultPadding / 2),
            // Updated time row
            Row(
              children: [
                AppShimmers.container(context, height: 16, width: 16, radius: 8),
                const SizedBox(width: 4),
                AppShimmers.container(context, height: 14, width: context.width * 0.4, radius: 4),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
