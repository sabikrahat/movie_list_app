import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';

import '../../../../core/db/hive.dart';
import '../../../../localization/localization.dart';

part 'locale_model.g.dart';
part 'locale_model_ext.dart';

@HiveType(typeId: HiveTypes.localeProfile)
enum LocaleProfile {
  @HiveField(0)
  bengali,
  @HiveField(1)
  english,
}
