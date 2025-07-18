part of 'settings_model.dart';

extension AppSettingsDBExt on AppSettings {
  Future<void> saveData() async => await Boxes.appSettings.put(appName.toCamelWord, this);

  Future<void> deleteData() async => await Boxes.appSettings.delete(appName.toCamelWord);

  Future<void> clearData() async => await Boxes.appSettings.clear();
}
