import 'package:flutter/widgets.dart';

import '../../core/config/constants.dart';
import '../../core/utils/extensions/extensions.dart';

class TitleSection extends StatelessWidget {
  const TitleSection({super.key, required this.title, this.count});

  final String title;
  final int? count;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainCenter,
      children: [
        Text(
          '⦿ $title',
          style: context.text.labelLarge!.copyWith(color: context.theme.primaryColor),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(left: 10.0, top: 2.0),
            height: 1.0,
            color: context.theme.primaryColor,
          ),
        ),
        if (count != null)
          Text(
            'Total $count items',
            style: context.text.labelSmall!.copyWith(color: context.theme.primaryColor),
          ),
      ],
    );
  }
}
