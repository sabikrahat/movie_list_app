import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/locale/locale_model.dart';
import '../model/settings_model.dart';
import 'settings_provider.dart';

typedef LocaleNotifier = NotifierProvider<LocaleProvider, LocaleProfile>;

final localeProvider = LocaleNotifier(LocaleProvider.new);

class LocaleProvider extends Notifier<LocaleProfile> {
  @override
  LocaleProfile build() => ref.watch(settingsProvider.select((v) => v.locale));

  Future<void> changeLocale(LocaleProfile locale) async =>
      await ref.read(settingsProvider).copyWith(locale: locale).saveData();
}
