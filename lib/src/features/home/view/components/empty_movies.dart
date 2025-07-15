import 'package:flutter/material.dart';
import '../../../../core/config/constants.dart';
import '../../../../core/utils/extensions/extensions.dart';

import '../../../../core/config/size.dart';

class EmptyMoviesView extends StatelessWidget {
  const EmptyMoviesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: mainCenter,
        children: [
          Icon(Icons.movie_outlined, size: 40, color: context.theme.dividerColor),
          const SizedBox(height: defaultPadding),
          Text(
            'No movies yet',
            style: context.text.titleLarge?.copyWith(color: context.theme.dividerColor),
          ),
          const SizedBox(height: defaultPadding / 2),
          Text(
            'Tap the + button to add your first movie',
            style: context.text.bodyMedium?.copyWith(color: context.theme.dividerColor),
          ),
        ],
      ),
    );
  }
}
