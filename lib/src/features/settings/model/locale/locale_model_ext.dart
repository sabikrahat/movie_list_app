part of 'locale_model.dart';

extension LocaleProfileExtension on LocaleProfile {
  Locale get locale {
    switch (this) {
      case LocaleProfile.bengali:
        return bnLocale;
      case LocaleProfile.english:
        return enLocale;
    }
  }

  String get label {
    switch (this) {
      case LocaleProfile.bengali:
        return t.bengali;
      case LocaleProfile.english:
        return t.english;
    }
  }

  String get languageCode {
    switch (this) {
      case LocaleProfile.bengali:
        return 'bn';
      case LocaleProfile.english:
        return 'en';
    }
  }

  bool get isEnglish => this == LocaleProfile.english;

  bool get isBengali => this == LocaleProfile.bengali;
}
