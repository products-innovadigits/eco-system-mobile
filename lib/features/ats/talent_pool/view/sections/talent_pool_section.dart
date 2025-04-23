import 'package:eco_system/components/shimmer/custom_shimmer.dart';
import 'package:eco_system/core/app_state.dart';
import 'package:eco_system/core/app_strings/locale_keys.dart';
import 'package:eco_system/core/assets.gen.dart';
import 'package:eco_system/features/ats/candidates/view/sections/total_candidates_section.dart';
import 'package:eco_system/features/ats/talent_pool/bloc/talent_pool_bloc.dart';
import 'package:eco_system/helpers/translation/all_translation.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/app_event.dart';
import '../../../../../helpers/styles.dart';
import '../../../../../widgets/section_title.dart';

class TalentPoolSection extends StatelessWidget {
  const TalentPoolSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TalentPoolBloc()..add(Click()),
      child: BlocBuilder<TalentPoolBloc, AppState>(
        builder: (context, state) {
          if (state is Done) {
            TalentPoolBloc talentPoolBloc = context.read<TalentPoolBloc>();
            return Container(
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
                    subText:
                        allTranslations.text(LocaleKeys.candidate_with_future_potential),
                    icon: Assets.svgs.tripleUser.path,
                    onViewTap: () {},
                  ),
                  Divider(color: Styles.BORDER_COLOR),
                  SizedBox(height: 12.h),
                  TotalCandidatesSection(),
                ],
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
          } else {
            return SizedBox();
          }
        },
      ),
    );
  }
}
