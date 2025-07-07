import 'package:ats_package/profile/view/widgets/answers_tab/wh_question_widget.dart';
import 'package:ats_package/profile/view/widgets/answers_tab/yes_no_question_widget.dart';
import 'package:core_package/core/utility/export.dart';


class AnswersSection extends StatelessWidget {
  const AnswersSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        YesNoQuestionWidget(
            question: 'هل لديك أي خبرة في سوق المملكة العربية السعودية؟',
            isCorrect: true),
        12.sh,
        WhQuestionWidget(
            question: 'هل يمكنك أن تخبرنا عن تجربتك السابقة في تصميم الواجهات؟',
            answer:
                'هل لديك أي خبرة في سوق المملكة العربية السعودية . هل لديك أي خبرة في سوق المملكة العربية السعودي .')
      ],
    );
  }
}
