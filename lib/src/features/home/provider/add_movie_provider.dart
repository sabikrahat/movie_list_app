import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/movie_model.dart';
import '../../../core/shared/ksnackbar/ksnackbar.dart';
import '../../../core/utils/extensions/extensions.dart';
import '../../../core/utils/logger/logger_helper.dart';

typedef AddMovieNotifier = AutoDisposeNotifierProviderFamily<AddMovieProvider, void, Movie?>;

final addMovieProvider = AddMovieNotifier(AddMovieProvider.new);

class AddMovieProvider extends AutoDisposeFamilyNotifier<void, Movie?> {
  final formKey = GlobalKey<FormState>();
  final titleCntrlr = TextEditingController();
  final descriptionCntrlr = TextEditingController();
  late DateTime created;

  bool isLoading = false;

  @override
  void build(Movie? arg) {
    if (arg != null) {
      titleCntrlr.text = arg.title;
      descriptionCntrlr.text = arg.description;
      created = arg.created;
    } else {
      created = DateTime.now();
    }
  }

  void setTitleAndDescription(String? title, String? description) {
    titleCntrlr.text = title ?? '';
    descriptionCntrlr.text = description ?? '';
  }

  void setCreatedDateTime(DateTime date) {
    created = date;
    ref.notifyListeners();
  }

  Future<void> submit(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;
    try {
      isLoading = true;
      ref.notifyListeners();
      final data = arg == null
          ? (Movie()
              ..title = titleCntrlr.text
              ..description = descriptionCntrlr.text
              ..created = created
              ..updated = DateTime.now())
          : arg!.copyWith(
              title: titleCntrlr.textOrNull,
              description: descriptionCntrlr.textOrNull,
              created: created,
              updated: DateTime.now(),
            );
      log.d('Movie data: $data');
      await data.saveData();
      if (context.mounted) context.pop();
    } catch (e) {
      log.e('Error occurred while adding movie: $e');
      if (!context.mounted) return;
      KSnackbar.error(context, '$e');
      return;
    } finally {
      isLoading = false;
      ref.notifyListeners();
    }
  }

  Future<void> delete(BuildContext context) async {
    try {
      if (arg == null) return;
      EasyLoading.show();
      await arg!.deleteData();
      EasyLoading.dismiss();
      if (!context.mounted) return;
      context.pop();
      context.pop();
      KSnackbar.success(context, 'Movie deleted successfully.');
    } catch (e) {
      log.e('Error occurred while deleting movie: $e');
      if (!context.mounted) return;
      KSnackbar.error(context, '$e');
      return;
    }
  }
}
