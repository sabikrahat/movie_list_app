// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppSettingsAdapter extends TypeAdapter<AppSettings> {
  @override
  final typeId = 2;

  @override
  AppSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppSettings()
      ..firstRun = fields[0] as bool
      ..firstRunDateTime = fields[1] as DateTime
      ..isProduction = fields[2] as bool
      ..performanceOverlayEnable = fields[3] as bool
      ..fontFamily = fields[4] as String
      ..theme = fields[5] as ThemeProfile
      ..locale = fields[6] as LocaleProfile
      ..dateFormat = fields[7] as String
      ..timeFormat = fields[8] as String;
  }

  @override
  void write(BinaryWriter writer, AppSettings obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.firstRun)
      ..writeByte(1)
      ..write(obj.firstRunDateTime)
      ..writeByte(2)
      ..write(obj.isProduction)
      ..writeByte(3)
      ..write(obj.performanceOverlayEnable)
      ..writeByte(4)
      ..write(obj.fontFamily)
      ..writeByte(5)
      ..write(obj.theme)
      ..writeByte(6)
      ..write(obj.locale)
      ..writeByte(7)
      ..write(obj.dateFormat)
      ..writeByte(8)
      ..write(obj.timeFormat);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
