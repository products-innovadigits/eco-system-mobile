import 'package:eco_system/features/ats/candidates/view/sections/candidate_stages_list_section.dart';
import 'package:eco_system/utility/export.dart';

class StagesSection extends StatelessWidget {
  final bool? isExpanded;
  final JobDataModel? jobDataModel;
  const StagesSection({super.key, this.isExpanded, this.jobDataModel});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      margin: EdgeInsets.only(top: isExpanded == true ? 12.h : 0),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        opacity: isExpanded == true ? 1.0 : 0.0,
        child: isExpanded == true
            ? CandidateStagesListSection(
            stages: jobDataModel?.stages ?? [],
            jobTitle: jobDataModel?.title ?? '')
            : const SizedBox.shrink(),
      ),
    );
  }
}
