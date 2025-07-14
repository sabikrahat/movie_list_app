import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import '../../injector.dart';
import '../config/get_platform.dart';
import '../db/init.dart';
import '../shared/error_view/error_view.dart';
import '../utils/logger/logger_helper.dart';

class Initializer {
  Initializer._();

  static void init(VoidCallback runApp) {
    ErrorWidget.builder = (errorDetails) {
      return AppErrorView(message: errorDetails.exceptionAsString());
    };

    runZonedGuarded(
      () async {
        WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

        // Native Slpash
        FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

        // Initialize Services
        await _initServices();

        // Remove Native Slpash
        FlutterNativeSplash.remove();
        runApp();
      },
      (error, stack) {
        log.i('runZonedGuarded: ${error.toString()}');
      },
    );
  }

  static Future<void> _initServices() async {
    try {
      await initializeServiceLocator();
      _configEasyLoading();
      await openDB();
      await initAppDatum();
      if (sl<PT>().isWeb) setUrlStrategy(PathUrlStrategy());
    } catch (err) {
      rethrow;
    }
  }

  static void _configEasyLoading() => EasyLoading.instance
    ..dismissOnTap = false
    ..userInteractions = false
    ..maskType = EasyLoadingMaskType.black
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle;
}
