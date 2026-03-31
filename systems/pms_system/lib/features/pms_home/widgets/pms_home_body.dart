import 'package:core_system/core/components/custom_screen_type_layout_widget.dart';
import 'package:pms_system/features/pms_home/widgets/cycles_summary_landscape_card.dart';
import 'package:pms_system/features/pms_home/widgets/employee_of_the_month_landscape.dart';
import 'package:pms_system/features/pms_home/widgets/employee_of_the_month_portrait.dart';
import 'package:pms_system/features/pms_home/widgets/employees_learning_card.dart';
import 'package:pms_system/features/pms_home/widgets/employees_learning_landscape_card.dart';

import '../../../core/utility/pms_exports.dart';
import 'cycles_summary_card.dart';

class PmsHomeBody extends StatelessWidget {
  const PmsHomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          spacing: 16.h,
          children: [
            SizedBox(height: 70.h),
            CustomScreenTypeLayoutWidget(
              mobilePortrait: (ctx) => CyclesSummaryCard(isPMSHome: true),
              mobileLandscape: (ctx) =>
                  CyclesSummaryLandscapeCard(isPMSHome: true),
            ),
            CustomScreenTypeLayoutWidget(
              mobilePortrait: (ctx) => const EmployeesLearningCard(),
              mobileLandscape: (ctx) => const EmployeesLearningLandscapeCard(),
            ),
            CustomScreenTypeLayoutWidget(
              mobilePortrait: (ctx) =>
                  EmployeeOfTheMonthPortraitCard(isPMSHome: true),
              mobileLandscape: (ctx) =>
                  EmployeeOfTheMonthLandscapeCard(isPMSHome: true),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
