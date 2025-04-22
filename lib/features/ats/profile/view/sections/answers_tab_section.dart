import 'package:eco_system/features/ats/profile/view/widgets/wh_question_widget.dart';
import 'package:eco_system/features/ats/profile/view/widgets/yes_no_question_widget.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:flutter/material.dart';

class AnswersTabSection extends StatelessWidget {
  const AnswersTabSection({super.key});

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
