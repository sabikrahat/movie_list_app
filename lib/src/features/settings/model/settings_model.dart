import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive_ce/hive.dart';
import 'package:intl/intl.dart';

import '../../../core/config/constants.dart';
import '../../../core/db/hive.dart';
import '../../../core/utils/extensions/extensions.dart';
import '../provider/date_format_provider.dart';
import '../provider/time_format_provider.dart';
import 'locale/locale_model.dart';
import 'theme/theme_model.dart';

part 'settings_model.g.dart';
part 'settings_model_crud_ext.dart';
part 'settings_model_ext.dart';

@HiveType(typeId: HiveTypes.appSettings)
class AppSettings extends HiveObject {
  AppSettings();

  @HiveField(0)
  bool firstRun = true;
  @HiveField(1)
  DateTime firstRunDateTime = DateTime.now().toUtc();
  @HiveField(2)
  bool isProduction = kReleaseMode;
  @HiveField(3)
  bool performanceOverlayEnable = false;
  @HiveField(4)
  String fontFamily = 'Urbanist';
  @HiveField(5)
  ThemeProfile theme = ThemeProfile.light;
  @HiveField(6)
  LocaleProfile locale = LocaleProfile.english;
  @HiveField(7)
  String dateFormat = dateFormates.first;
  @HiveField(8)
  String timeFormat = timeFormates.first;

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
    'isFirstRun': firstRun,
    'firstRunDateTime': firstRunDateTime.toIso8601String(),
    'isProduction': isProduction,
    'performanceOverlayEnable': performanceOverlayEnable,
    'fontFamily': fontFamily,
    'theme': theme.name,
    'locale': locale.name,
    'dateFormat': dateFormat,
    'timeFormat': timeFormat,
  };

  factory AppSettings.fromJson(String source) => AppSettings.fromRawJson(json.decode(source));

  factory AppSettings.fromRawJson(Map<String, dynamic> json) => AppSettings()
    ..firstRun = json['firstRun'] as bool
    ..firstRunDateTime = DateTime.parse(json['firstRunDateTime'] as String)
    ..isProduction = json['isProduction'] as bool
    ..performanceOverlayEnable = json['performanceOverlayEnable'] as bool
    ..fontFamily = json['fontFamily'] as String
    ..theme = ThemeProfile.values.firstWhere(
      (e) => e.name == json['theme'] as String,
      orElse: () => ThemeProfile.light,
    )
    ..locale = LocaleProfile.values.firstWhere(
      (e) => e.name == json['locale'] as String,
      orElse: () => LocaleProfile.english,
    )
    ..dateFormat = json['dateFormat'] as String
    ..timeFormat = json['timeFormat'] as String;

  @override
  String toString() => toRawJson();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppSettings &&
        other.firstRunDateTime.microsecondsSinceEpoch == firstRunDateTime.microsecondsSinceEpoch;
  }

  @override
  int get hashCode => firstRunDateTime.microsecondsSinceEpoch;
}
