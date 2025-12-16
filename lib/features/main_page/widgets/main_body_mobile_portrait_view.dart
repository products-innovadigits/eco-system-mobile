import 'package:core_system/core/utility/export.dart';

class MainBodyMobilePortraitView extends StatelessWidget {
  const MainBodyMobilePortraitView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          spacing: 16.h,
          children: [
            SizedBox(height: 70),
            if (UserBloc.activeSystems.contains(ActiveSystemEnum.strategy))
              ObjectivePercentageSection(),
            if (UserBloc.activeSystems.contains(ActiveSystemEnum.pms)) ...[
              ProjectManagementSection(),
              // ProjectCategoryProgressSection(),
              // if (UserBloc.activeSystems.contains(ActiveSystemEnum.ats)) ...[
              //   AvailableJobsSection(),
              //   TalentPoolSection(),
              // ],
              16.sh,
            ],
          ],
        ),
      ),
    );
  }
}
