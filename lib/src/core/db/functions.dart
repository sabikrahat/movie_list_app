import 'package:hive_ce/hive.dart';

import '../../features/home/model/movie_model.dart';
import '../../features/settings/model/locale/locale_model.dart';
import '../../features/settings/model/settings_model.dart';
import '../../features/settings/model/theme/theme_model.dart';
import 'hive.dart';

class HiveFuntions {
  static void registerHiveAdepters() {
    Hive.registerAdapter(LocaleProfileAdapter());
    Hive.registerAdapter(ThemeProfileAdapter());
    Hive.registerAdapter(AppSettingsAdapter());
    Hive.registerAdapter(MovieAdapter());
  }

  static Future<void> openAllBoxes() async {
    await Hive.openBox<LocaleProfile>(BoxNames.localeProfile);
    await Hive.openBox<ThemeProfile>(BoxNames.themeProfile);
    await Hive.openBox<AppSettings>(BoxNames.appSettings);
    await Hive.openBox<Movie>(BoxNames.movies);
  }

  static Future<void> closeAllBoxes() async {
    await Boxes.localeProfile.close();
    await Boxes.themeProfile.close();
    await Boxes.appSettings.close();
    await Boxes.movies.close();
  }

  static Future<void> clearAllBoxes() async {
    await Boxes.localeProfile.clear();
    await Boxes.themeProfile.clear();
    await Boxes.appSettings.clear();
    await Boxes.movies.clear();
  }

  static Future<void> deleteAllBoxes() async {
    await Hive.deleteBoxFromDisk(BoxNames.localeProfile);
    await Hive.deleteBoxFromDisk(BoxNames.themeProfile);
    await Hive.deleteBoxFromDisk(BoxNames.appSettings);
    await Hive.deleteBoxFromDisk(BoxNames.movies);
  }
}
