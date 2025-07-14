import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppMaintenanceBreakView extends StatelessWidget {
  const AppMaintenanceBreakView({super.key});

  static const String name = 'maintenance-break';

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
                  'assets/svgs/maintenance.svg',
                  semanticsLabel: 'Maintenance Break',
                  height: MediaQuery.sizeOf(context).width * 0.7,
                  width: MediaQuery.sizeOf(context).width * 0.7,
                ),
                MaintenanceInfo(
                  title: 'We are under maintenance.',
                  description:
                      'We are currently performing scheduled maintenance. We apologize for any inconvenience this may cause. Please check back later.',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MaintenanceInfo extends StatelessWidget {
  const MaintenanceInfo({
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
