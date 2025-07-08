import 'package:ats_package/candidates/view/sections/total_candidates_section.dart';
import 'package:ats_package/shared/ats_exports.dart';
import 'package:core_package/core/utility/export.dart';

class TalentPoolSection extends StatelessWidget {
  const TalentPoolSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          TalentPoolBloc()..add(Click(arguments: SearchEngine())),
      child: BlocBuilder<TalentPoolBloc, AppState>(
        builder: (context, state) {
          if (state is Done) {
            TalentPoolBloc talentPoolBloc = context.read<TalentPoolBloc>();
            return InkWell(
              onTap: () {
                context.read<FiltrationBloc>().reset();
                context.read<FiltrationBloc>().add(Click());
                CustomNavigator.push(Routes.TALENT_POOL);
              },
              child: Container(
                width: context.w,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                decoration: BoxDecoration(
                    color: Styles.WHITE_COLOR,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: context.color.outline)),
                child: Column(
                  children: [
                    SectionTitle(
                      title: allTranslations.text(LocaleKeys.talent_pool),
                      subText: allTranslations
                          .text(LocaleKeys.candidate_with_future_potential),
                      icon: Assets.svgs.tripleUser.path,
                      onViewTap: () {},
                    ),
                    Divider(color: context.color.outline),
                    12.sh,
                    TotalCandidatesSection(
                        talentsList: talentPoolBloc.talentsList,
                        candidatesCount: talentPoolBloc.candidatesCount ?? 0),
                  ],
                ),
              ),
            );
          }
          if (state is Loading) {
            return Padding(
              padding: EdgeInsets.only(top: 12.h),
              child: CustomShimmerContainer(
                height: context.h * 0.2,
                width: context.w,
              ),
            );
          }
          if (state is Error) {
            return Padding(
              padding: EdgeInsets.all(16.w),
              child: ErrorContainerWidget(
                  header: Column(
                    children: [
                      SectionTitle(
                        title: allTranslations.text(LocaleKeys.talent_pool),
                        subText: allTranslations
                            .text(LocaleKeys.candidate_with_future_potential),
                        icon: Assets.svgs.tripleUser.path,
                        onViewTap: () {},
                      ),
                      Divider(color: context.color.outline)
                    ],
                  ),
                  onTryAgain: () {
                    context
                        .read<TalentPoolBloc>()
                        .add(Click(arguments: SearchEngine()));
                  }),
            );
          } else {
            return Padding(
              padding: EdgeInsets.only(top: 24.h),
              child: EmptyContainer(
                txt: allTranslations.text(LocaleKeys.there_is_no_data),
              ),
            );
          }
        },
      ),
    );
  }
}
