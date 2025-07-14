import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../core/config/constants.dart';
import '../../../../core/shared/animations_widget/animated_popup.dart';
import '../../../../core/shared/animations_widget/animated_widget_shower.dart';
import '../../../../core/shared/list_tile/k_list_tile.dart';
import '../../../../core/utils/extensions/extensions.dart';
import '../../../../localization/localization.dart';

final infoProvider = FutureProvider((_) async => await PackageInfo.fromPlatform());

class AboutTile extends ConsumerWidget {
  const AboutTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final info = ref.watch(infoProvider).value;
    final bn = info?.buildNumber == '0' ? '' : '(${info?.buildNumber})';
    return KListTile(
      leading: AnimatedWidgetShower(
        size: 28.0,
        child: SvgPicture.asset(
          'assets/svgs/about.svg',
          colorFilter: context.theme.primaryColor.toColorFilter,
          semanticsLabel: 'About',
        ),
      ),
      title: Text(t.about, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: info == null ? null : Text('${t.appTitle} ${info.version}$bn'),
      onTap: () async => await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => KAboutDialog('${info?.version}$bn'),
      ),
    );
  }
}

class KAboutDialog extends StatelessWidget {
  const KAboutDialog(this.version, {super.key});

  final String version;

  @override
  Widget build(BuildContext context) {
    return AnimatedPopup(
      child: AlertDialog(
        title: Row(
          children: [
            SvgPicture.asset('assets/icons/app-icon.svg', height: 52, width: 52),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: crossStart,
                children: [
                  Text(appName, style: context.text.titleLarge),
                  const SizedBox(height: 2),
                  Text(
                    version,
                    style: context.text.labelMedium!.copyWith(fontWeight: FontWeight.normal),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '© 2025 $appName. All rights reserved.',
                    style: context.text.labelMedium!.copyWith(fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: min(400, context.width),
          child: Column(
            mainAxisSize: mainMin,
            children: [
              Text(
                '\nThis app is built with Flutter and Dart, and it is open source. You can find the source code on GitHub.',
                style: context.text.labelMedium,
                textAlign: TextAlign.justify,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '\n- Algoramming.',
                  style: context.text.labelMedium!.copyWith(color: context.theme.primaryColor),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Close',
              style: TextStyle(color: context.theme.dividerColor.withValues(alpha: 0.8)),
            ),
          ),
          TextButton(
            onPressed: () => showLicensePage(context: context),
            child: Text('View licenses', style: TextStyle(color: context.theme.primaryColor)),
          ),
        ],
      ),
    );
  }
}
