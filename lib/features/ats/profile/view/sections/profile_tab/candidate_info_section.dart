import 'package:eco_system/features/ats/profile/view/widgets/profile_tab/candidate_info_card_widget.dart';
import 'package:eco_system/features/ats/talent_pool/model/candidate_model.dart';
import 'package:eco_system/utility/export.dart';

class CandidateInfoSection extends StatelessWidget {
  const CandidateInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    final CandidateModel? candidateModel =
        context.read<ProfileBloc>().candidateModel;
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
            title: allTranslations.text(LocaleKeys.location),
            value: candidateModel?.profile?.location ?? '-'),
        CandidateInfoCardWidget(
            title: allTranslations.text(LocaleKeys.expected_salary),
            value: candidateModel?.profile?.expectedSalary ?? '-',
            isPrimaryColor: false),
        CandidateInfoCardWidget(
            title: allTranslations.text(LocaleKeys.notice_period),
            value: candidateModel?.profile?.noticePeriod ?? '-',
            isPrimaryColor: false),
        CandidateInfoCardWidget(
            title: allTranslations.text(LocaleKeys.candidate_source),
            value: candidateModel?.source ?? '-'),
      ],
    );
  }
}
