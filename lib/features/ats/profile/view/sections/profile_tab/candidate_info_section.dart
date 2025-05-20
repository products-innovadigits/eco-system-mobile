
import 'package:eco_system/utility/export.dart';

class CandidateInfoSection extends StatelessWidget {
  const CandidateInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8.h,
        crossAxisSpacing: 8.w,
        childAspectRatio: 2.5,
      ),
      // Number of items
      children: [
        CandidateInfoCardWidget(
            title: allTranslations.text(LocaleKeys.current_salary),
            value: '5000\$'),
        CandidateInfoCardWidget(
            title: allTranslations.text(LocaleKeys.expected_salary),
            value: '8000\$',
            isPrimaryColor: false),
        CandidateInfoCardWidget(
            title: allTranslations.text(LocaleKeys.notice_period),
            value: 'اسبوع',
            isPrimaryColor: false),
        CandidateInfoCardWidget(
            title: allTranslations.text(LocaleKeys.candidate_source),
            value: 'لينكد ان'),
      ],
    );
  }
}
