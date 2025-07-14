import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/shared/animations_widget/animated_popup.dart';
import '../../../../core/shared/animations_widget/animated_widget_shower.dart';
import '../../../../core/shared/list_tile/k_list_tile.dart';
import '../../../../core/utils/extensions/extensions.dart';
import '../../../../localization/localization.dart';
import '../../functions/delete_db.dart';

class DBDeleteTile extends StatelessWidget {
  const DBDeleteTile({super.key});

  @override
  Widget build(BuildContext context) {
    return KListTile(
      leading: AnimatedWidgetShower(
        size: 28.0,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: SvgPicture.asset(
            'assets/svgs/delete.svg',
            colorFilter: context.theme.primaryColor.toColorFilter,
            semanticsLabel: 'Delete Database',
          ),
        ),
      ),
      title: Text(
        t.deleteDatabase,
        textAlign: TextAlign.justify,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      onTap:
          () async => await showDialog(
            context: context,
            barrierDismissible: false,
            builder:
                (context) => DeleteDatabaseWarningPopup(onPressed: () async => await deleteDB()),
          ),
    );
  }
}

class DeleteDatabaseWarningPopup extends StatelessWidget {
  const DeleteDatabaseWarningPopup({super.key, this.onPressed});

  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return AnimatedPopup(
      child: AlertDialog(
        title: const Text('Warning'),
        content: SizedBox(
          width: min(context.width * 0.8, 400.0),
          child: const Text(
            'Are you sure you want to delete database? This will delete all your data and this action is irreversible. This will also close the app. You will have to manually start the app to use it again.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text(
              'Cancel',
              style: TextStyle(color: context.theme.dividerColor.withValues(alpha: 0.8)),
            ),
          ),
          TextButton(
            onPressed: onPressed,
            child: const Text(
              'DELETE',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
