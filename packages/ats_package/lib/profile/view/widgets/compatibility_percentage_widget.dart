import 'package:core_package/core/utility/export.dart';

class CompatibilityPercentageWidget extends StatelessWidget {
  final String title;
  final double percentage;

  const CompatibilityPercentageWidget(
      {super.key, required this.title, required this.percentage});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      decoration: BoxDecoration(
          color: Styles.PRIMARY_COLOR.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          Images(image: Assets.svgs.percentageCircle.path),
          8.sw,
          Text('$title : ',
              textDirection: TextDirection.rtl,
              style: AppTextStyles.w400.copyWith(color: Styles.TEXT_COLOR)),
          2.sw,
          Text('%${percentage.toInt()}',
              style: AppTextStyles.w800.copyWith(color: Styles.PRIMARY_COLOR)),
        ],
      ),
    );
  }
}
