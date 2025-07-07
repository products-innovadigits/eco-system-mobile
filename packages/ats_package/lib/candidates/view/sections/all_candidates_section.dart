import 'package:ats_package/shared/ats_exports.dart';
import 'package:core_package/core/utility/export.dart';

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
                    style: context.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                8.sw,
                Text('(${bloc.candidateCount})',
                    style: context.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
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
