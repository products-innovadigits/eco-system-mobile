import 'package:eco_system/utility/export.dart';

class CandidateDataSection extends StatelessWidget {
  const CandidateDataSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'السعودية',
          style: AppTextStyles.w500.copyWith(
              color: Styles.SUB_TEXT_DARK_COLOR, fontSize: 10),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Icon(Icons.circle,
              color: Styles.SUB_TEXT_DARK_COLOR, size: 4),
        ),
        Text(
          'خبرة ٥ سنين',
          style: AppTextStyles.w500.copyWith(
              color: Styles.SUB_TEXT_DARK_COLOR, fontSize: 10),
        ),
        const Spacer(),
        Text(
          '\$ غير متوفر .',
          style: AppTextStyles.w500
              .copyWith(color: Styles.PRIMARY_COLOR, fontSize: 10),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child:
          Icon(Icons.circle, color: Styles.PRIMARY_COLOR, size: 4),
        ),
        Text(
          'اسبوعين',
          style: AppTextStyles.w500
              .copyWith(color: Styles.PRIMARY_COLOR, fontSize: 10),
        ),
      ],
    );
  }
}
