// import 'package:pms_system/core/utility/pms_exports.dart';
//
// class CycleReportsHeader extends StatelessWidget {
//   const CycleReportsHeader({super.key, required this.cycleName});
//
//   final String cycleName;
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           allTranslations.text(LocaleKeys.reports),
//           style: context.textTheme.headlineSmall?.copyWith(
//             fontWeight: FontWeight.w700,
//             color: context.color.onSurface,
//           ),
//         ),
//         SizedBox(height: 4.h),
//         Text(
//           '${allTranslations.text(LocaleKeys.cycle_colon)} $cycleName',
//           style: context.textTheme.bodyMedium?.copyWith(
//             color: context.color.outlineVariant,
//             fontSize: FontSizes.f14,
//           ),
//         ),
//       ],
//     );
//   }
// }
