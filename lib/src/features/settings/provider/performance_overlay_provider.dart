import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/settings_model.dart';
import 'settings_provider.dart';

typedef PerformanceOverlayNotifier = NotifierProvider<PerformanceOverlayProvider, bool>;

final performanceOverlayProvider = PerformanceOverlayNotifier(PerformanceOverlayProvider.new);

class PerformanceOverlayProvider extends Notifier<bool> {
  @override
  bool build() => ref.watch(settingsProvider.select((v) => v.performanceOverlayEnable));

  Future<void> changePerformanceOverlay(bool isEnable) async =>
      await ref.read(settingsProvider).copyWith(performanceOverlayEnable: isEnable).saveData();
}
