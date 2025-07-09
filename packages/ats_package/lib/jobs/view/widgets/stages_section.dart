import 'package:ats_package/shared/ats_exports.dart';
import 'package:core_package/core/utility/export.dart';

class StagesSection extends StatelessWidget {
  final bool? isExpanded;
  final JobDataModel? jobDataModel;

  const StagesSection({super.key, this.isExpanded, this.jobDataModel});

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      crossFadeState: isExpanded == true
          ? CrossFadeState.showSecond
          : CrossFadeState.showFirst,
      duration: const Duration(milliseconds: 400),
      firstChild: SizedBox.shrink(),
      secondChild: CandidateStagesListSection(
        stages: jobDataModel?.stages ?? [],
        jobTitle: jobDataModel?.title ?? '',
      ),
    );
  }
}
