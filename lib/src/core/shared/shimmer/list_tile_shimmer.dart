// import 'package:flutter/material.dart';

// import '../../../features/app_components/modules/singlechildscrollview.dart';
// import '../../utils/extensions/extensions.dart';
// import 'shimmer.dart';

// class ShimmerListTileLoader extends StatelessWidget {
//   const ShimmerListTileLoader({super.key, this.length = 10});

//   final int length;

//   @override
//   Widget build(BuildContext context) {
//     return KSingleChildScrollView(
//       child: Column(
//         children: List.generate(
//           length,
//           (idx) => Padding(
//             padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
//             child: Card(
//               child: AppShimmer.container(
//                 height: 80,
//                 baseColor: context.theme.cardColor,
//                 highlightColor: context.theme.scaffoldBackgroundColor,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
