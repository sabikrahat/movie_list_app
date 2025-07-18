import 'package:hive_ce/hive.dart';

import '../../features/home/model/movie_model.dart';
import '../../features/settings/model/locale/locale_model.dart';
import '../../features/settings/model/settings_model.dart';
import '../../features/settings/model/theme/theme_model.dart';

class Boxes {
  static Box<LocaleProfile> localeProfile = Hive.box<LocaleProfile>(BoxNames.localeProfile);
  static Box<ThemeProfile> themeProfile = Hive.box<ThemeProfile>(BoxNames.themeProfile);
  static Box<AppSettings> appSettings = Hive.box<AppSettings>(BoxNames.appSettings);
  static Box<Movie> movies = Hive.box<Movie>(BoxNames.movies);
}

class BoxNames {
  static const String localeProfile = 'localeProfile';
  static const String themeProfile = 'themeProfile';
  static const String appSettings = 'appSettings';
  static const String movies = 'movies';
}

class HiveTypes {
  static const int localeProfile = 0;
  static const int themeProfile = 1;
  static const int appSettings = 2;
  static const int movies = 3;
}
