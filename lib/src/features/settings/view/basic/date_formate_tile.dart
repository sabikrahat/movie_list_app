import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../../../../core/config/constants.dart';
import '../../../../core/config/size.dart';
import '../../../../core/shared/animations_widget/animated_popup.dart';
import '../../../../core/shared/animations_widget/animated_widget_shower.dart';
import '../../../../core/shared/list_tile/k_list_tile.dart';
import '../../../../core/utils/extensions/extensions.dart';
import '../../../../localization/localization.dart';
import '../../provider/date_format_provider.dart';

class DateFormatTile extends StatelessWidget {
  const DateFormatTile({super.key});

  @override
  Widget build(BuildContext context) {
    return KListTile(
      leading: AnimatedWidgetShower(
        size: 28.0,
        child: SvgPicture.asset(
          'assets/svgs/date-format.svg',
          colorFilter: context.theme.primaryColor.toColorFilter,
          semanticsLabel: 'Date Format',
        ),
      ),
      title: Text(t.dateFormat, style: const TextStyle(fontWeight: FontWeight.bold)),
      trailing: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(50, 48),
          backgroundColor: context.theme.cardColor,
        ),
        onPressed: () async => await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const DateFormatChangerPopup(),
        ),
        label: Icon(Icons.arrow_forward_ios_rounded, size: 15.0, color: context.theme.primaryColor),
        icon: Consumer(
          builder: (_, ref, _) {
            return Text(
              DateFormat(ref.watch(dateFormatProvider)).format(DateTime.now()),
              style: context.theme.textTheme.bodySmall!.copyWith(fontSize: 13.0),
            );
          },
        ),
      ),
    );
  }
}

class DateFormatChangerPopup extends ConsumerWidget {
  const DateFormatChangerPopup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnimatedPopup(
      child: AlertDialog(
        backgroundColor: context.theme.scaffoldBackgroundColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: defaultPadding),
        insetPadding: const EdgeInsets.all(defaultPadding * 1.5),
        titlePadding: const EdgeInsets.all(defaultPadding),
        shape: defaultRoundedRectangleBorder,
        title: Row(
          children: [
            Expanded(child: const Text('Select Date Format')),
            SizedBox(width: defaultPadding / 2),
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
                dateFormates.length,
                (index) => KListTile(
                  onTap: () async => await ref
                      .read(dateFormatProvider.notifier)
                      .changeDateFormat(dateFormates[index])
                      .then((_) {
                        if (!context.mounted) return;
                        context.pop();
                      }),
                  leading: Radio<String?>(
                    value: dateFormates[index],
                    groupValue: ref.watch(dateFormatProvider),
                    onChanged: (v) async =>
                        await ref.read(dateFormatProvider.notifier).changeDateFormat(v!).then((_) {
                          if (!context.mounted) return;
                          context.pop();
                        }),
                  ),
                  title: Text(DateFormat(dateFormates[index]).format(DateTime.now())),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
