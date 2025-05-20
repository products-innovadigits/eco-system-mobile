import 'package:eco_system/utility/export.dart';

class WhQuestionWidget extends StatelessWidget {
  final String question;
  final String answer;

  const WhQuestionWidget(
      {super.key, required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Color(0xffE6F5F4).withValues(alpha: 0.4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(question, style: AppTextStyles.w400.copyWith(fontSize: 11)),
          8.sh,
          Text(answer,
              style: AppTextStyles.w400
                  .copyWith(fontSize: 10, color: Styles.SUB_TEXT_DARK_COLOR)),
        ],
      ),
    );
  }
}
