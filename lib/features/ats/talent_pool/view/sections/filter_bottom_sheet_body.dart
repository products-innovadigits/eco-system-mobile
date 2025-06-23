import 'package:eco_system/utility/export.dart';

class FilterBottomSheetBody extends StatelessWidget {
  final CandidateFilterModel filterModel;
  const FilterBottomSheetBody({super.key, required this.filterModel});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.h * 0.65,
      child: ListView(
        children: [
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
