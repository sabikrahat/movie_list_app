import 'package:flutter/material.dart';

import '../../../../core/config/constants.dart';
import '../../../../core/config/size.dart';
import '../../../../core/exception/exception.dart';
import '../../../../core/utils/extensions/extensions.dart';

class ErrorView extends StatelessWidget {
  const ErrorView({super.key, required this.error, required this.onRetry});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: mainCenter,
        children: [
          Icon(Icons.error_outline, size: 40, color: Colors.red),
          const SizedBox(height: defaultPadding),
          Text('Error loading movies', style: context.text.titleLarge?.copyWith(color: Colors.red)),
          const SizedBox(height: defaultPadding / 2),
          Text(
            error is KException
                ? (error as KException).message
                : 'An unexpected error occurred: ${error.toString()}',
            style: context.text.bodyMedium?.copyWith(color: context.theme.dividerColor),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: defaultPadding),
          ElevatedButton(onPressed: onRetry, child: const Icon(Icons.refresh)),
        ],
      ),
    );
  }
}
