import 'package:hive_ce/hive.dart';
import 'package:movie_list_app/src/features/home/model/movie_model.dart';
import 'package:movie_list_app/src/features/settings/model/locale/locale_model.dart';
import 'package:movie_list_app/src/features/settings/model/settings_model.dart';
import 'package:movie_list_app/src/features/settings/model/theme/theme_model.dart';

class HiveTestHelper {
  static Future<void> initializeHive() async {
    Hive.init('./test_db');
    
    // Register all adapters
    if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(LocaleProfileAdapter());
    if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(ThemeProfileAdapter());
    if (!Hive.isAdapterRegistered(2)) Hive.registerAdapter(AppSettingsAdapter());
    if (!Hive.isAdapterRegistered(3)) Hive.registerAdapter(MovieAdapter());
    
    // Open all required boxes
    if (!Hive.isBoxOpen('localeProfile')) {
      await Hive.openBox<LocaleProfile>('localeProfile');
    }
    if (!Hive.isBoxOpen('themeProfile')) {
      await Hive.openBox<ThemeProfile>('themeProfile');
    }
    if (!Hive.isBoxOpen('appSettings')) {
      await Hive.openBox<AppSettings>('appSettings');
    }
    if (!Hive.isBoxOpen('movies')) {
      await Hive.openBox<Movie>('movies');
    }
  }

  static Future<void> clearAllBoxes() async {
    if (Hive.isBoxOpen('localeProfile')) {
      await Hive.box<LocaleProfile>('localeProfile').clear();
    }
    if (Hive.isBoxOpen('themeProfile')) {
      await Hive.box<ThemeProfile>('themeProfile').clear();
    }
    if (Hive.isBoxOpen('appSettings')) {
      await Hive.box<AppSettings>('appSettings').clear();
    }
    if (Hive.isBoxOpen('movies')) {
      await Hive.box<Movie>('movies').clear();
    }
  }

  static Future<void> cleanupHive() async {
    await Hive.close();
  }
}