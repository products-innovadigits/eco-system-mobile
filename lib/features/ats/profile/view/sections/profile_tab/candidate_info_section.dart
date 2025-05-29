import 'package:eco_system/features/ats/profile/view/widgets/profile_tab/candidate_info_card_widget.dart';
import 'package:eco_system/utility/export.dart';
import 'package:shimmer/shimmer.dart';

class CandidateInfoSection extends StatelessWidget {
  const CandidateInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, AppState>(
      builder: (context, state) {
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
          children: state is Loading
              ? List.generate(4, (index) => _buildShimmerCard())
              : [
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
      },
    );
  }
}

Widget _buildShimmerCard() {
  return Shimmer.fromColors(
    baseColor: Colors.grey[200]!,
    highlightColor: Colors.grey[100]!,
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 12,
            color: Colors.white,
          ),
          SizedBox(height: 8.h),
          Container(
            width: 40,
            height: 12,
            color: Colors.white,
          ),
        ],
      ),
    ),
  );
}
