import 'package:flutter/material.dart';

import '../../core/utils/extensions/extensions.dart';
import '../settings/view/setting_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  static const String name = 'home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () async => await context.goPush(SettingsView.name),
          ),
        ],
      ),
      body: Center(
        child: Text('Welcome to the Home Page', style: Theme.of(context).textTheme.headlineMedium),
      ),
    );
  }
}
