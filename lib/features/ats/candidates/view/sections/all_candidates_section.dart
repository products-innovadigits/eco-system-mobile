import 'package:eco_system/core/app_state.dart';
import 'package:eco_system/features/ats/candidates/bloc/candidates_bloc.dart';
import 'package:eco_system/features/ats/candidates/view/sections/stage_section.dart';
import 'package:eco_system/helpers/styles.dart';
import 'package:eco_system/helpers/text_styles.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllCandidatesSection extends StatelessWidget {
  const AllCandidatesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CandidatesBloc, AppState>(
      builder: (context, state) {
        final bloc = context.read<CandidatesBloc>();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('قائد فريق تصميم المنتجات',
                    style: AppTextStyles.w700.copyWith(fontSize: 14)),
                8.sw,
                Text('(32)',
                    style: AppTextStyles.w600.copyWith(
                        color: Styles.PRIMARY_COLOR, fontSize: 14)),
              ],
            ),
            16.sh,
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: bloc.stages.length,
              itemBuilder: (context, index) {
                final stage = bloc.stages[index];
                return StageSection(
                  key: bloc.keys[stage],
                  stageName: stage,
                );
              },
              separatorBuilder: (context, index) => 16.sh,
            ),
          ],
        );
      },
    );
  }
}
