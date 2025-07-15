import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/config/constants.dart';
import '../../../../core/utils/extensions/extensions.dart';
import '../../../../core/utils/themes/themes.dart';

import '../../../../core/config/size.dart';
import '../../../../injector.dart';
import '../../../app_components/page_padding.dart';
import '../../../settings/model/settings_model.dart';
import '../../model/movie_model.dart';
import '../../provider/home_provider.dart';
import '../add_movie.dart';

class MoviesListView extends ConsumerWidget {
  const MoviesListView({super.key, required this.movies});

  final List<Movie> movies;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(homeProvider);
    final notifier = ref.read(homeProvider.notifier);
    return RefreshIndicator(
      color: white,
      onRefresh: () async => await notifier.refresh(showLoader: false),
      child: PagePadding(
        child: ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) {
            final movie = movies[index];
            return MovieCard(
              movie: movie,
              onTap: () async => await showAddMovieBottomSheet(
                context,
                movie: movie,
              ).then((_) async => await notifier.refresh()),
              onFavoriteToggle: () async => await notifier.toggleFavorite(movie),
              onDuplicate: () async => await showAddMovieBottomSheet(
                context,
                title: movie.title,
                description: movie.description,
              ).then((_) async => await notifier.refresh()),
            );
          },
        ),
      ),
    );
  }
}

class MovieCard extends StatelessWidget {
  const MovieCard({
    super.key,
    required this.movie,
    required this.onTap,
    required this.onFavoriteToggle,
    required this.onDuplicate,
  });

  final Movie movie;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onDuplicate;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: defaultPadding),
      shape: defaultRoundedRectangleBorder,
      child: InkWell(
        onTap: onTap,
        borderRadius: defaultBorderRadius,
        child: Padding(
          padding: const EdgeInsets.all(defaultPadding * 0.75),
          child: Row(
            crossAxisAlignment: crossStart,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: crossStart,
                  children: [
                    Text(
                      movie.title,
                      style: context.text.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: defaultPadding / 2),
                    Text(
                      movie.description,
                      style: context.text.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: defaultPadding / 2),
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 16, color: context.theme.dividerColor),
                        const SizedBox(width: 4),
                        Text(
                          'Created on ${sl<AppSettings>().getDateTimeFormat.format(movie.updated)}',
                          style: context.text.bodySmall?.copyWith(
                            color: context.theme.dividerColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  IconButton(
                    icon: Icon(
                      movie.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: movie.isFavorite ? Colors.red : null,
                    ),
                    onPressed: onFavoriteToggle,
                  ),
                  IconButton(icon: const Icon(Icons.copy), onPressed: onDuplicate),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
