import 'package:ats_package/shared/ats_exports.dart';
import 'package:core_package/core/utility/export.dart';

class CandidateStagesListSection extends StatelessWidget {
  final List<StageModel> stages;
  final String jobTitle;

  const CandidateStagesListSection(
      {super.key, required this.stages, required this.jobTitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        12.sh,
        ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final Color stageColor = stages[index].color != null
                  ? Color(int.parse('0xFF' + stages[index].color!.substring(1)))
                  : Styles.PRIMARY_COLOR;
              return InkWell(
                onTap: () {
                  context.read<FiltrationBloc>().reset();
                  CustomNavigator.push(
                    Routes.CANDIDATES,
                    arguments: InitCandidates(
                        targetStage: stages[index].type,
                        stages: stages,
                        jobTitle: jobTitle),

                    // arguments: stageKeys.keys.elementAt(index)
                  );
                  context.read<JobsBloc>().add(Expand(arguments: -1));
                },
                child: Row(
                  children: [
                    Icon(Icons.circle, size: 10, color: stageColor),
                    SizedBox(width: 8.w),
                    Text(
                      // stageKeys.keys.elementAt(index),
                      stages[index].type ?? '',
                      style: AppTextStyles.w400.copyWith(fontSize: 10),
                    ),
                    const Spacer(),
                    Images(image: Assets.svgs.arrowLeft.path, width: 7),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) => 16.sh,
            itemCount: stages.length),
      ],
    );
  }
}
