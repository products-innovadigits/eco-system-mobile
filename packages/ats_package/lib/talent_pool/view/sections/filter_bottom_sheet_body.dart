import 'package:core_package/core/utility/export.dart';

import '../../../candidates/view/widgets/expected_salary_widget.dart';
import '../../../candidates/view/widgets/gender.dart';
import '../../../candidates/view/widgets/skills.dart';
import '../../../candidates/view/widgets/tags.dart';
import '../../model/candidate_filter_model.dart';

class FilterBottomSheetBody extends StatelessWidget {
  final CandidateFilterModel filterModel;
  const FilterBottomSheetBody({super.key, required this.filterModel});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.h * 0.60,
      child: ListAnimator(
        data: [
          16.sh,
          Skills(selectedSkills: filterModel.selectedSkills),
          16.sh,
          Tags(selectedTags: filterModel.selectedTags),
          16.sh,
          ExpectedSalary(),
          16.sh,
          // Experience(),
          // 16.sh,
          // Location(),
          // 16.sh,
          Gender(),
        ],
      ),
    );
  }
}
