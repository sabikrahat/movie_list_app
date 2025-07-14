import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/settings_model.dart';
import 'settings_provider.dart';

const timeFormates = ['hh:mm a', 'hh:mm:ss a', 'hh:mm', 'hh:mm:ss', 'HH:mm', 'HH:mm:ss'];

typedef TimeFormatNotifier = NotifierProvider<TimeFormatProvider, String>;

final timeFormatProvider = TimeFormatNotifier(TimeFormatProvider.new);

class TimeFormatProvider extends Notifier<String> {
  @override
  String build() => ref.watch(settingsProvider.select((v) => v.timeFormat));

  Future<void> changeTimeFormat(String timeFormat) async =>
      await ref.read(settingsProvider).copyWith(timeFormat: timeFormat).saveData();
}
