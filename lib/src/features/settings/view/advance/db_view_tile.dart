import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/config/get_platform.dart';
import '../../../../core/shared/animations_widget/animated_popup.dart';
import '../../../../core/shared/animations_widget/animated_widget_shower.dart';
import '../../../../core/shared/ksnackbar/ksnackbar.dart';
import '../../../../core/shared/list_tile/k_list_tile.dart';
import '../../../../core/utils/extensions/extensions.dart';
import '../../../../injector.dart';
import '../../../../localization/localization.dart';

class DBViewTile extends StatelessWidget {
  const DBViewTile({super.key});

  @override
  Widget build(BuildContext context) {
    return KListTile(
      leading: AnimatedWidgetShower(
        size: 28.0,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: SvgPicture.asset(
            'assets/svgs/db-view.svg',
            colorFilter: context.theme.primaryColor.toColorFilter,
            semanticsLabel: 'Delete Database',
          ),
        ),
      ),
      title: Text(t.viewDatabase, style: const TextStyle(fontWeight: FontWeight.bold)),
      onTap: () async {
        if (sl<PT>().isWeb) {
          await showDialog(context: context, builder: (_) => const HiveDbViewWebPopup());
          return;
        }
        KSnackbar.warning(context, 'This feature is not available now.');
      },
    );
  }
}

class HiveDbViewWebPopup extends StatelessWidget {
  const HiveDbViewWebPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedPopup(
      child: AlertDialog(
        title: Text(t.viewDatabase),
        content: SizedBox(
          width: min(400, context.width),
          child: const Text(
            'This feature is not available in web. However, you can use the following instructions to view the database:\n\n'
            '1. Right click on the screen and select "Inspect Element".\n'
            '2. Go to "Application" tab.\n'
            '3. Select "IndexedDB" from the left panel.\n'
            '4. Select the database from the list.\n'
            '5. Select the table from the list.\n'
            '6. Select the data from the list.\n'
            '7. You can also delete the data from the list. (Recommended not to delete data from here.)',
            textAlign: TextAlign.justify,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Ok', style: TextStyle(color: context.theme.primaryColor)),
          ),
        ],
      ),
    );
  }
}
