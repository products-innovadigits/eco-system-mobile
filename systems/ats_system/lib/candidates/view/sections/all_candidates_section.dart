import 'package:ats_system/shared/ats_exports.dart';
import 'package:core_system/core/utility/export.dart';

class AllCandidatesSection extends StatelessWidget {
  const AllCandidatesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CandidatesBloc, AppState>(
      builder: (context, state) {
        final bloc = context.read<CandidatesBloc>();
        return ListView.separated(
          controller: bloc.scrollController,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          itemCount: 1 + bloc.stages.length,
          separatorBuilder: (context, index) => index == 0 ? 8.sh : 16.sh,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Row(
                children: [
                  Text(
                    bloc.jobTitle,
                    style: context.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  8.sw,
                  Text(
                    '(${bloc.candidateCount})',
                    style: context.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              );
            }
            final stage = bloc.stages[index - 1];
            return StageSection(key: bloc.keys[stage], stage: stage);
          },
        );
      },
    );
  }
}
