import 'package:pms_system/features/pms_home/widgets/employee_of_the_month_card.dart';
import 'package:pms_system/features/pms_home/widgets/employees_learning_card.dart';

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
            const CyclesSummaryCard(),
            const EmployeesLearningCard(),
            const EmployeeOfTheMonthCard(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
