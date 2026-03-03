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
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }
}
