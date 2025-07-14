part of '../extensions.dart';


extension TextEditingControllerUtils on TextEditingController {
  String? get textOrNull => text.isEmpty ? null : text;
}
