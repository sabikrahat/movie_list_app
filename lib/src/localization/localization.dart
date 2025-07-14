import 'package:flutter/material.dart' show BuildContext, Locale;
import 'package:flutter_gen/gen_l10n/app_localizations.dart' show AppLocalizations;
import 'package:flutter_localizations/flutter_localizations.dart'
    show GlobalCupertinoLocalizations, GlobalMaterialLocalizations, GlobalWidgetsLocalizations;

late AppLocalizations t;

const localizationsDelegates = [
  AppLocalizations.delegate,
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
];

String onGenerateTitle(BuildContext context) => AppLocalizations.of(context)!.appTitle;

const supportedLocales = [bnLocale, enLocale];

const bnLocale = Locale('bn', 'bn_BD');
const enLocale = Locale('en', 'en_US');
