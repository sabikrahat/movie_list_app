import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/settings_model.dart';
import 'settings_provider.dart';

const dateFormates = [
  'dd MMM, yy',
  'dd MMM, yyyy',
  'dd/MM/yy',
  'dd/MM/yyyy',
  'dd-MM-yy',
  'dd-MM-yyyy',
  'dd, MM yy',
  'dd, MM yyyy',
  'dd.MM.yy',
  'dd.MM.yyyy',
  'dd MM yy',
  'dd MM yyyy',
];

typedef DateFormatNotifier = NotifierProvider<DateFormatProvider, String>;

final dateFormatProvider = DateFormatNotifier(DateFormatProvider.new);

class DateFormatProvider extends Notifier<String> {
  @override
  String build() => ref.watch(settingsProvider.select((v) => v.dateFormat));

  Future<void> changeDateFormat(String dateFormat) async =>
      await ref.read(settingsProvider).copyWith(dateFormat: dateFormat).saveData();
}
