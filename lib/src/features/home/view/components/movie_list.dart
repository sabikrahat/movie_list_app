import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/themes/themes.dart';
import '../../../app_components/page_padding.dart';
import '../../model/movie_model.dart';
import '../../provider/home_provider.dart';
import 'movie_card.dart';

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
            return MovieCard(movie: movie);
          },
        ),
      ),
    );
  }
}
