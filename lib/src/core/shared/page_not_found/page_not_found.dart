import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../config/constants.dart';
import '../../utils/extensions/extensions.dart';

class KPageNotFound extends StatelessWidget {
  const KPageNotFound({super.key, this.error});

  final Object? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: mainMin,
            mainAxisAlignment: mainCenter,
            children: [
              Lottie.asset('assets/lottie/empty.json', width: 200, height: 200),
              Text(
                error?.toString() ?? '404 - Page not found!',
                textAlign: TextAlign.center,
                style: context.text.bodyLarge?.copyWith(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
