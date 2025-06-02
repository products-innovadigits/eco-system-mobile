import 'package:eco_system/features/ats/candidates/view/sections/total_candidates_section.dart';
import 'package:eco_system/features/ats/talent_pool/bloc/talent_pool_bloc.dart';
import 'package:eco_system/utility/export.dart';

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
                CustomNavigator.push(Routes.TALENT_POOL);
              },
              child: Container(
                width: context.w,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                    color: Styles.WHITE_COLOR,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Styles.LIGHT_GREY_BORDER)),
                child: Column(
                  children: [
                    SectionTitle(
                      title: allTranslations.text(LocaleKeys.talent_pool),
                      subText: allTranslations
                          .text(LocaleKeys.candidate_with_future_potential),
                      icon: Assets.svgs.tripleUser.path,
                      onViewTap: () {},
                    ),
                    Divider(color: Styles.BORDER_COLOR),
                    12.sh,
                    TotalCandidatesSection(
                        talentsList: talentPoolBloc.talentsList),
                  ],
                ),
              ),
            );
          }
          if (state is Loading) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: CustomShimmerContainer(
                height: context.h * 0.2,
                width: context.w,
              ),
            );
          }
          else {
            return Padding(
              padding: EdgeInsets.only(top: 24.h),
              child: EmptyContainer(
                  txt: state is Error
                      ? allTranslations.text(LocaleKeys.something_went_wrong)
                      : allTranslations.text(LocaleKeys.there_is_no_data)),
            );
          }
        },
      ),
    );
  }
}
