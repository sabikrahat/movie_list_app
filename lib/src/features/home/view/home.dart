import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/extensions/extensions.dart';
import '../../settings/view/setting_view.dart';
import '../provider/home_provider.dart';
import 'add_movie.dart';
import 'components/empty_movies.dart';
import 'components/error_view.dart';
import 'components/movie_list.dart';
import 'components/movie_shimmer.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  static const String name = 'home';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(homeProvider);
    final notifier = ref.read(homeProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () async => await context.goPush(SettingsView.name),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () async =>
            await showAddMovieBottomSheet(context).then((_) async => await notifier.refresh()),
        child: const Icon(Icons.add),
      ),
      body: ref
          .watch(homeProvider)
          .when(
            loading: () => MovieShimmerLoader(),
            error: (err, _) => ErrorView(error: err, onRetry: () async => await notifier.refresh()),
            data: (_) => notifier.data.isEmpty
                ? const EmptyMoviesView()
                : MoviesListView(movies: notifier.data),
          ),
    );
  }
}
