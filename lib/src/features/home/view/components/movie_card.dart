import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/config/constants.dart';
import '../../../../core/config/size.dart';

import '../../../../core/utils/extensions/extensions.dart';
import '../../../../injector.dart';
import '../../../settings/model/settings_model.dart';
import '../../model/movie_model.dart';
import '../../provider/home_provider.dart';
import '../add_movie.dart';
import 'movie_details_popup.dart';

class MovieCard extends ConsumerWidget {
  const MovieCard({super.key, required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(homeProvider);
    final notifier = ref.read(homeProvider.notifier);
    return Container(
      margin: const EdgeInsets.only(bottom: defaultPadding * 0.75),
      decoration: BoxDecoration(
        color: context.theme.cardColor,
        borderRadius: defaultBorderRadius,
        boxShadow: [
          BoxShadow(
            color: context.theme.shadowColor.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: context.theme.dividerColor.withValues(alpha: 0.1), width: 1),
      ),
      child: ClipRRect(
        borderRadius: defaultBorderRadius,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => showMovieDetailsPopup(context, movie),
            borderRadius: defaultBorderRadius,
            child: Padding(
              padding: const EdgeInsets.all(defaultPadding * 0.75),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with title and actions
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          movie.title,
                          style: context.text.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: context.theme.primaryColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _ActionButton(
                        icon: movie.isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: movie.isFavorite ? Colors.red : context.theme.iconTheme.color,
                        onPressed: () => notifier.toggleFavorite(movie),
                        tooltip: movie.isFavorite ? 'Remove from favorites' : 'Add to favorites',
                      ),
                      const SizedBox(width: 4),
                      _ActionButton(
                        icon: Icons.edit_outlined,
                        color: context.theme.iconTheme.color,
                        onPressed: () => _showEditMovie(context, notifier),
                        tooltip: 'Edit movie',
                      ),
                      const SizedBox(width: 4),
                      _ActionButton(
                        icon: Icons.copy_outlined,
                        color: context.theme.iconTheme.color,
                        onPressed: () => _duplicateMovie(context, notifier),
                        tooltip: 'Duplicate movie',
                      ),
                    ],
                  ),

                  // Description
                  const SizedBox(height: defaultPadding * 0.75),
                  Text(
                    movie.description,
                    style: context.text.bodyMedium?.copyWith(
                      color: context.theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.8),
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // Footer with timestamp and favorite indicator
                  const SizedBox(height: defaultPadding * 0.75),
                  Row(
                    children: [
                      Icon(Icons.schedule_outlined, size: 14, color: context.theme.dividerColor),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          'Updated ${_getRelativeTime(movie.updated)}',
                          style: context.text.bodySmall?.copyWith(
                            color: context.theme.dividerColor,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      if (movie.isFavorite) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.red.withValues(alpha: 0.1),
                            borderRadius: defaultBorderRadius,
                            border: Border.all(color: Colors.red.withValues(alpha: 0.3), width: 1),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.favorite, size: 12, color: Colors.red.shade600),
                              const SizedBox(width: 4),
                              Text(
                                'Favorite',
                                style: context.text.bodySmall?.copyWith(
                                  color: Colors.red.shade600,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showEditMovie(BuildContext context, HomeProvider notifier) async =>
      await showAddMovieBottomSheet(
        context,
        movie: movie,
      ).then((_) async => await notifier.refresh());

  Future<void> _duplicateMovie(BuildContext context, HomeProvider notifier) async =>
      await showAddMovieBottomSheet(
        context,
        title: movie.title,
        description: movie.description,
      ).then((_) async => await notifier.refresh());

  String _getRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      if (difference.inDays == 1) return '1 day ago';
      if (difference.inDays < 7) return '${difference.inDays} days ago';
      if (difference.inDays < 30) return '${(difference.inDays / 7).floor()} weeks ago';
      if (difference.inDays < 365) return '${(difference.inDays / 30).floor()} months ago';
      return sl<AppSettings>().getDateTimeFormat.format(dateTime);
    } else if (difference.inHours > 0) {
      return difference.inHours == 1 ? '1 hour ago' : '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return difference.inMinutes == 1 ? '1 minute ago' : '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.icon, required this.onPressed, this.color, this.tooltip});

  final IconData icon;
  final VoidCallback onPressed;
  final Color? color;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final button = Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: borderRadius100,
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: (color?.computeLuminance() ?? 0) > 0.5
                ? Colors.black.withValues(alpha: 0.05)
                : Colors.white.withValues(alpha: 0.05),
          ),
          child: Icon(icon, size: 18, color: color),
        ),
      ),
    );

    if (tooltip != null) return Tooltip(message: tooltip!, child: button);

    return button;
  }
}
