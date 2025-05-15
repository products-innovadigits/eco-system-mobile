import 'package:eco_system/utility/export.dart';

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
                Text(bloc.jobTitle,
                    style: AppTextStyles.w700.copyWith(fontSize: 14)),
                8.sw,
                Text('(${bloc.candidateCount})',
                    style: AppTextStyles.w600
                        .copyWith(color: Styles.PRIMARY_COLOR, fontSize: 14)),
              ],
            ),
            8.sh,
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: bloc.stages.length,
              itemBuilder: (context, index) {
                final stage = bloc.stages[index];
                return StageSection(
                  key: bloc.keys[stage],
                  stage: stage,
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
