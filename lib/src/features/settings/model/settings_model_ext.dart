part of 'settings_model.dart';

extension SettingExtension on AppSettings {
  AppSettings copyWith({
    bool? firstRun,
    DateTime? firstRunDateTime,
    bool? isProduction,
    bool? performanceOverlayEnable,
    String? fontFamily,
    ThemeProfile? theme,
    LocaleProfile? locale,
    String? dateFormat,
    String? timeFormat,
  }) => AppSettings()
    ..firstRun = firstRun ?? this.firstRun
    ..firstRunDateTime = firstRunDateTime ?? this.firstRunDateTime
    ..isProduction = isProduction ?? this.isProduction
    ..performanceOverlayEnable = performanceOverlayEnable ?? this.performanceOverlayEnable
    ..fontFamily = fontFamily ?? this.fontFamily
    ..theme = theme ?? this.theme
    ..locale = locale ?? this.locale
    ..dateFormat = dateFormat ?? this.dateFormat
    ..timeFormat = timeFormat ?? this.timeFormat;

  DateFormat get getDateFormat => DateFormat(dateFormat);

  DateFormat get getTimeFormat => DateFormat(timeFormat);

  DateFormat get getDateTimeFormat => DateFormat('$dateFormat $timeFormat');
}
