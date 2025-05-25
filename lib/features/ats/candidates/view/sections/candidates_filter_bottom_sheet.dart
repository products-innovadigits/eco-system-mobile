import 'package:eco_system/features/ats/candidates/view/sections/application_date.dart';
import 'package:eco_system/features/ats/candidates/view/widgets/compatibility_rate.dart';
import 'package:eco_system/features/ats/candidates/view/widgets/expected_salary_widget.dart';
import 'package:eco_system/features/ats/candidates/view/widgets/experience.dart';
import 'package:eco_system/features/ats/candidates/view/widgets/gender.dart';
import 'package:eco_system/features/ats/candidates/view/widgets/location.dart';
import 'package:eco_system/features/ats/candidates/view/widgets/qualified.dart';
import 'package:eco_system/features/ats/candidates/view/widgets/skills.dart';
import 'package:eco_system/features/ats/candidates/view/widgets/tags.dart';
import 'package:eco_system/utility/export.dart';

class CandidatesFilterBottomSheet extends StatelessWidget {
  const CandidatesFilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FiltrationBloc, AppState>(
      builder: (context, state) {
        return Stack(
          children: [
            Column(
              children: [
                BottomSheetHeader(title: LocaleKeys.candidate),
                SizedBox(
                  height: context.h * 0.8,
                  child: ListView(
                    children: [
                      Skills(selectedSkills: []),
                      16.sh,
                      Tags(selectedTags: []),
                      16.sh,
                      ExpectedSalary(),
                      16.sh,
                      Experience(),
                      16.sh,
                      Location(),
                      16.sh,
                      Gender(),
                      16.sh,
                      Qualified(),
                      16.sh,
                      ApplicationDate(),
                      16.sh,
                      CompatibilityRate(),
                      60.sh
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              child: CustomBtn(
                  width: context.w * 0.9,
                  text: allTranslations.text(LocaleKeys.show_all_results),
                  onPressed: () {}),
            )
          ],
        );
      },
    );
  }
}
