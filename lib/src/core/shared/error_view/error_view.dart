import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppErrorView extends StatelessWidget {
  final String message;

  const AppErrorView({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 8,
              children: [
                SvgPicture.asset(
                  'assets/svgs/error.svg',
                  height: MediaQuery.sizeOf(context).width * 0.7,
                  width: MediaQuery.sizeOf(context).width * 0.7,
                ),
                ErrorInfo(title: 'Oops! Something went wrong!', description: 'Error $message'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ErrorInfo extends StatelessWidget {
  const ErrorInfo({
    super.key,
    required this.title,
    required this.description,
  });

  final String title, description;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 16,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
            ),
            Text(
              description,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
