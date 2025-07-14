import 'package:flutter/material.dart';

import '../../../core/config/constants.dart';
import '../../app_components/singlechildscrollview.dart';
import 'advance/db_delete_tile.dart';
import 'advance/db_view_tile.dart';
import 'advance/performance_overlay_tile.dart';
import 'basic/about_tile.dart';
import 'basic/date_formate_tile.dart';
import 'basic/locale_tile.dart';
import 'basic/theme_tile.dart';
import 'basic/time_formate_tile.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  static const String name = 'settings';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), centerTitle: true, elevation: 0.0),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: DefaultTabController(
            length: 2,
            child: NestedScrollView(
              headerSliverBuilder: (_, _) => [
                SliverToBoxAdapter(
                  child: TabBar(
                    tabAlignment: TabAlignment.start,
                    splashBorderRadius: borderRadius30,
                    isScrollable: true,
                    physics: const BouncingScrollPhysics(),
                    tabs: const [
                      Tab(text: 'Basic'),
                      Tab(text: 'Advanced'),
                    ],
                  ),
                ),
              ],
              body: const TabBarView(children: [BasicPart(), AdvancePart()]),
            ),
          ),
        ),
      ),
    );
  }
}

class BasicPart extends StatelessWidget {
  const BasicPart({super.key});

  @override
  Widget build(BuildContext context) {
    return const KSingleChildScrollView(
      child: Column(
        children: [ThemeTile(), LocaleTile(), DateFormatTile(), TimeFormatTile(), AboutTile()],
      ),
    );
  }
}

class AdvancePart extends StatelessWidget {
  const AdvancePart({super.key});

  @override
  Widget build(BuildContext context) {
    return const KSingleChildScrollView(
      child: Column(children: [PerformanceOverlayTile(), DBDeleteTile(), DBViewTile()]),
    );
  }
}
