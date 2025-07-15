import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import '../model/movie_model.dart';

import '../../../core/config/constants.dart';
import '../../../core/config/size.dart';
import '../../../core/shared/animations_widget/animated_popup.dart';
import '../../../core/utils/extensions/extensions.dart';
import '../../../injector.dart';
import '../../app_components/page_padding.dart';
import '../../app_components/singlechildscrollview.dart';
import '../../settings/model/settings_model.dart';
import '../provider/add_movie_provider.dart';

Future<void> showAddMovieBottomSheet(
  BuildContext context, {
  Movie? movie,
  String? title,
  String? description,
}) async {
  await showModalBottomSheet(
    backgroundColor: context.theme.scaffoldBackgroundColor,
    elevation: 2.0,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16.0),
        topRight: Radius.circular(16.0),
      ),
    ),
    context: context,
    isDismissible: true,
    isScrollControlled: true,
    useRootNavigator: true,
    useSafeArea: true,
    builder: (_) => AddMovieView(movie: movie, title: title, description: description),
  );
}

class AddMovieView extends ConsumerWidget {
  const AddMovieView({super.key, this.movie, this.title, this.description});

  final Movie? movie;
  final String? title;
  final String? description;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(addMovieProvider(movie));
    final notifier = ref.read(addMovieProvider(movie).notifier);
    if (title != null || description != null) notifier.setTitleAndDescription(title, description);
    return Padding(
      padding: EdgeInsets.only(bottom: context.mq.viewInsets.bottom),
      child: PagePadding(
        child: Form(
          key: notifier.formKey,
          child: KSingleChildScrollView(
            child: Column(
              mainAxisSize: mainMin,
              crossAxisAlignment: crossStart,
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: defaultPadding / 3),
                    width: 60.0,
                    height: 3.0,
                    decoration: BoxDecoration(
                      color: context.theme.dividerColor,
                      borderRadius: borderRadius60,
                    ),
                  ),
                ),
                const SizedBox(height: defaultPadding / 2),
                Row(
                  mainAxisAlignment: mainSpaceBetween,
                  children: [
                    SizedBox(width: 30, height: 30),
                    Text(
                      movie == null ? 'Add Movie' : 'Edit Movie',
                      style: context.text.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: InkWell(
                        borderRadius: borderRadius60,
                        onTap: context.pop,
                        child: const Icon(Icons.close),
                      ),
                    ),
                  ],
                ),
                const Divider(thickness: 1.0),
                const SizedBox(height: defaultPadding),
                Text(
                  'Title',
                  style: context.text.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: defaultPadding / 3),
                TextFormField(
                  style: context.text.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                  controller: notifier.titleCntrlr,
                  decoration: const InputDecoration(hintText: 'Enter movie title'),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onTapOutside: (_) => FocusScope.of(context).unfocus(),
                  validator: (v) => v.isNullOrEmpty ? 'Please enter a movie title' : null,
                ),
                const SizedBox(height: defaultPadding * 0.75),
                Text(
                  'Description',
                  style: context.text.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: defaultPadding / 3),
                TextFormField(
                  style: context.text.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                  controller: notifier.descriptionCntrlr,
                  decoration: const InputDecoration(
                    hintText: 'Enter movie description',
                    contentPadding: EdgeInsets.symmetric(
                      vertical: defaultPadding / 2,
                      horizontal: defaultPadding,
                    ),
                  ),
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.text,
                  maxLines: 5,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onTapOutside: (_) => FocusScope.of(context).unfocus(),
                  validator: (_) => null,
                ),
                const SizedBox(height: defaultPadding * 5),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: defaultPadding / 2),
                      child: RichText(
                        text: TextSpan(
                          text:
                              'Created on ${sl<AppSettings>().getDateTimeFormat.format(notifier.created)}',
                          style: context.text.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: context.theme.dividerColor,
                          ),
                          children: [
                            TextSpan(
                              text: ' | Change | ',
                              style: context.text.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: context.theme.primaryColor,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  final date = await showBoardDateTimePicker(
                                    context: context,
                                    pickerType: DateTimePickerType.datetime,
                                    initialDate: notifier.created,
                                    minimumDate: DateTime.now().subtract(
                                      const Duration(days: 365 * 50),
                                    ),
                                    maximumDate: DateTime.now().addDays(365),
                                    options: BoardDateTimeOptions(
                                      startDayOfWeek: DateTime.saturday,
                                      pickerFormat: PickerFormat.dmy,
                                      useAmpm: true,
                                    ),
                                  );
                                  if (date == null) return;
                                  notifier.setCreatedDateTime(date);
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (movie != null) ...[
                          IconButton(
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.red.shade100,
                              shape: const CircleBorder(),
                            ),
                            onPressed: () async => await showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (_) => MovieDeletePopup(
                                onPressed: () async => await notifier.delete(context),
                              ),
                            ),
                            icon: SvgPicture.asset(
                              'assets/svgs/delete.svg',
                              colorFilter: Colors.red.toColorFilter,
                              semanticsLabel: 'Edit',
                            ),
                          ),
                          const SizedBox(width: defaultPadding / 4),
                        ],
                        Expanded(
                          child: OutlinedButton(
                            onPressed: context.pop,
                            child: const Text('Cancel'),
                          ),
                        ),
                        const SizedBox(width: defaultPadding / 4),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: notifier.isLoading
                                ? null
                                : () async => await notifier.submit(context),
                            child: notifier.isLoading
                                ? SpinKitThreeBounce(color: context.theme.primaryColor, size: 20)
                                : Text(movie == null ? 'Save' : 'Update'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MovieDeletePopup extends StatelessWidget {
  const MovieDeletePopup({super.key, required this.onPressed});

  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return AnimatedPopup(
      child: AlertDialog(
        backgroundColor: context.theme.scaffoldBackgroundColor,
        title: const Text('Warning'),
        content: const Text(
          'Are you sure you want to delete this movie? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: context.pop,
            child: Text(
              'Cancel',
              style: TextStyle(color: context.theme.dividerColor.withValues(alpha: 0.8)),
            ),
          ),
          TextButton(
            onPressed: onPressed,
            child: const Text('Confirm', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
