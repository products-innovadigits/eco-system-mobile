import 'package:core_system/core/utility/export.dart';

import '../../../candidates/view/widgets/expected_salary_widget.dart';
import '../../../candidates/view/widgets/gender.dart';
import '../../../candidates/view/widgets/skills.dart';
import '../../../candidates/view/widgets/tags.dart';
import '../../model/candidate_filter_model.dart';

class AtsFilterBottomSheetBody extends StatelessWidget {
  final CandidateFilterModel filterModel;
  const AtsFilterBottomSheetBody({super.key, required this.filterModel});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.h * 0.60,
      child: ListAnimator(
        data: [
          SizedBox(height: 16.h),
          Skills(selectedSkills: filterModel.selectedSkills),
          SizedBox(height: 16.h),
          Tags(selectedTags: filterModel.selectedTags),
          SizedBox(height: 16.h),
          ExpectedSalary(),
          SizedBox(height: 16.h),
          // Experience(),
          // SizedBox(height: 16.h),
          // Location(),
          // SizedBox(height: 16.h),
          Gender(),
        ],
      ),
    );
  }
}
