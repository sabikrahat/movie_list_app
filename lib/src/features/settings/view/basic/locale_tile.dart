import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/config/constants.dart';
import '../../../../core/config/size.dart';
import '../../../../core/shared/animations_widget/animated_popup.dart';
import '../../../../core/shared/animations_widget/animated_widget_shower.dart';
import '../../../../core/shared/list_tile/k_list_tile.dart';
import '../../../../core/utils/extensions/extensions.dart';
import '../../../../localization/localization.dart';
import '../../model/locale/locale_model.dart';
import '../../provider/locale_provider.dart';

class LocaleTile extends StatelessWidget {
  const LocaleTile({super.key});

  @override
  Widget build(BuildContext context) {
    return KListTile(
      leading: AnimatedWidgetShower(
        size: 28.0,
        child: SvgPicture.asset(
          'assets/svgs/language.svg',
          colorFilter: context.theme.primaryColor.toColorFilter,
          semanticsLabel: 'Language',
        ),
      ),
      title: Text(t.language, style: const TextStyle(fontWeight: FontWeight.bold)),
      trailing: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(50, 48),
          backgroundColor: context.theme.cardColor,
        ),
        onPressed: () async => await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => const LocaleChangerPopup(),
        ),
        label: Icon(Icons.arrow_forward_ios_rounded, size: 15.0, color: context.theme.primaryColor),
        icon: Consumer(
          builder: (_, ref, _) {
            final locale = ref.watch(localeProvider);
            return Text(
              locale.label,
              style: context.theme.textTheme.bodySmall!.copyWith(fontSize: 13.0),
            );
          },
        ),
      ),
    );
  }
}

class LocaleChangerPopup extends StatelessWidget {
  const LocaleChangerPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedPopup(
      child: AlertDialog(
        backgroundColor: context.theme.scaffoldBackgroundColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: defaultPadding),
        insetPadding: const EdgeInsets.all(defaultPadding * 1.5),
        titlePadding: const EdgeInsets.all(defaultPadding),
        shape: defaultRoundedRectangleBorder,
        title: Row(
          children: [
            Expanded(child: Text(t.selectLanguage)),
            const SizedBox(width: defaultPadding / 2),
            InkWell(
              customBorder: roundedRectangleBorder30,
              onTap: context.pop,
              child: const Icon(Icons.close),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            children: [
              ...List.generate(
                LocaleProfile.values.length,
                (index) => Consumer(
                  builder: (_, ref, _) => KListTile(
                    onTap: () async => await ref
                        .read(localeProvider.notifier)
                        .changeLocale(LocaleProfile.values[index])
                        .then((_) {
                          if (!context.mounted) return;
                          context.pop();
                        }),
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                    leading: Radio<LocaleProfile?>(
                      value: LocaleProfile.values[index],
                      groupValue: ref.watch(localeProvider),
                      onChanged: (v) async =>
                          await ref.read(localeProvider.notifier).changeLocale(v!).then((_) {
                            if (!context.mounted) return;
                            context.pop();
                          }),
                    ),
                    title: Text(LocaleProfile.values[index].label),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
