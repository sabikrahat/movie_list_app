import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/config/constants.dart';

import '../../../../core/config/size.dart';
import '../../../../core/shared/animations_widget/animated_popup.dart';
import '../../../../core/utils/extensions/extensions.dart';
import '../../../../injector.dart';
import '../../../settings/model/settings_model.dart';
import '../../model/movie_model.dart';
import '../../provider/home_provider.dart';
import '../add_movie.dart';

Future<void> showMovieDetailsPopup(BuildContext context, Movie movie) async {
  await showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => MovieDetailsPopup(movie: movie),
  );
}

class MovieDetailsPopup extends ConsumerWidget {
  const MovieDetailsPopup({super.key, required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(homeProvider.notifier);
    return AnimatedPopup(
      child: AlertDialog(
        scrollable: true,
        backgroundColor: context.theme.scaffoldBackgroundColor,
        insetPadding: const EdgeInsets.all(defaultPadding * 1.5),
        shape: defaultRoundedRectangleBorder,
        contentPadding: EdgeInsets.zero,
        titlePadding: EdgeInsets.zero,
        actionsPadding: const EdgeInsets.symmetric(
          horizontal: defaultPadding,
          vertical: defaultPadding / 2,
        ),
        title: Container(
          padding: const EdgeInsets.all(defaultPadding),
          decoration: BoxDecoration(
            color: context.theme.primaryColor.withValues(alpha: 0.05),
            borderRadius: BorderRadius.only(
              topLeft: defaultBorderRadius.topLeft,
              topRight: defaultBorderRadius.topRight,
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.movie_outlined, color: context.theme.primaryColor, size: 24),
              const SizedBox(width: defaultPadding / 2),
              Expanded(
                child: Text(
                  movie.title,
                  style: context.text.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: context.theme.primaryColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              InkWell(
                borderRadius: borderRadius100,
                onTap: context.pop,
                child: Container(
                  padding: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    color: context.theme.primaryColor.withValues(alpha: 0.3),
                    borderRadius: borderRadius100,
                  ),
                  child: Icon(Icons.close, color: context.theme.primaryColor),
                ),
              ),
            ],
          ),
        ),
        content: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: context.width * 0.9,
            maxHeight: context.height * 0.6,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Column(
                crossAxisAlignment: crossStart,
                mainAxisSize: mainMin,
                children: [
                  // Favorite status indicator
                  _FavoriteIndicator(movie: movie),
                  const SizedBox(height: defaultPadding),

                  // Description section
                  Text(
                    'Description',
                    textAlign: TextAlign.justify,
                    style: context.text.labelMedium?.copyWith(
                      color: context.theme.dividerColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (movie.description.isNotEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: context.theme.cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: context.theme.dividerColor.withValues(alpha: 0.1),
                        ),
                      ),
                      child: Text(
                        movie.description,
                        style: context.text.bodyMedium?.copyWith(
                          height: 1.5,
                          color: context.theme.textTheme.bodyMedium?.color,
                        ),
                      ),
                    )
                  else
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: context.theme.dividerColor.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: context.theme.dividerColor.withValues(alpha: 0.1),
                        ),
                      ),
                      child: Text(
                        'No description available',
                        style: context.text.bodyMedium?.copyWith(
                          color: context.theme.dividerColor,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),

                  const SizedBox(height: 20),

                  // Metadata section
                  Text(
                    'Details',
                    style: context.text.labelMedium?.copyWith(
                      color: context.theme.dividerColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: context.theme.cardColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: context.theme.dividerColor.withValues(alpha: 0.1)),
                    ),
                    child: Column(
                      children: [
                        _MetadataRow(
                          icon: Icons.schedule_outlined,
                          label: 'Created',
                          value: sl<AppSettings>().getDateTimeFormat.format(movie.created),
                        ),
                        const SizedBox(height: 12),
                        _MetadataRow(
                          icon: Icons.update_outlined,
                          label: 'Last Updated',
                          value: sl<AppSettings>().getDateTimeFormat.format(movie.updated),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.copy_outlined, size: 18),
                  label: const Text('Duplicate'),
                  onPressed: () async {
                    context.pop();
                    await _duplicateMovie(context, notifier);
                  },
                ),
              ),
              const SizedBox(width: defaultPadding / 4),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    context.pop();
                    await _showEditMovie(context, notifier);
                  },
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  label: const Text('Edit'),
                ),
              ),
            ],
          ),
          // OutlinedButton.icon(
          //   onPressed: () {
          //     Navigator.of(context).pop();
          //     _duplicateMovie(context, notifier);
          //   },
          //   icon: const Icon(Icons.copy_outlined, size: 18),
          //   label: const Text('Duplicate'),
          // ),
          // ElevatedButton.icon(
          //   onPressed: () {
          //     Navigator.of(context).pop();
          //     _showEditMovie(context, notifier);
          //   },
          //   icon: const Icon(Icons.edit_outlined, size: 18),
          //   label: const Text('Edit'),
          // ),
        ],
      ),
    );
  }

  Future<void> _showEditMovie(BuildContext context, HomeProvider notifier) async {
    await showAddMovieBottomSheet(
      context,
      movie: movie,
    ).then((_) async => await notifier.refresh());
  }

  Future<void> _duplicateMovie(BuildContext context, HomeProvider notifier) async {
    await showAddMovieBottomSheet(
      context,
      title: movie.title,
      description: movie.description,
    ).then((_) async => await notifier.refresh());
  }
}

class _FavoriteIndicator extends StatelessWidget {
  const _FavoriteIndicator({required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(defaultPadding * 0.75),
      decoration: BoxDecoration(
        color: movie.isFavorite
            ? Colors.red.withValues(alpha: 0.1)
            : context.theme.dividerColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: movie.isFavorite
              ? Colors.red.withValues(alpha: 0.3)
              : context.theme.dividerColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(defaultPadding / 2),
            decoration: BoxDecoration(
              color: movie.isFavorite
                  ? Colors.red.withValues(alpha: 0.1)
                  : context.theme.dividerColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              movie.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: movie.isFavorite ? Colors.red : context.theme.dividerColor,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Favorite Status',
                  style: context.text.bodySmall?.copyWith(
                    color: context.theme.dividerColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  movie.isFavorite ? 'Added to favorites' : 'Not in favorites',
                  style: context.text.bodyMedium?.copyWith(
                    color: movie.isFavorite
                        ? Colors.red
                        : context.theme.textTheme.bodyMedium?.color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (movie.isFavorite)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Favorite',
                style: context.text.bodySmall?.copyWith(
                  color: Colors.red.shade700,
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _MetadataRow extends StatelessWidget {
  const _MetadataRow({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: context.theme.dividerColor),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: crossStart,
            children: [
              Text(
                label,
                style: context.text.bodySmall?.copyWith(
                  color: context.theme.dividerColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: context.text.bodyMedium?.copyWith(
                  color: context.theme.textTheme.bodyMedium?.color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
