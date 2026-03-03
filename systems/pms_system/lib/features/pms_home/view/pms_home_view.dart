import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/pms_home/widgets/cycles_summary_card.dart';

class PmsHomeView extends StatelessWidget {
  const PmsHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Stack(
          children: [MainHeader(), PmsHomeBody()],
        ),
      ),
    );
  }
}

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
            SizedBox(height: 80.h),
            const CyclesSummaryCard(),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }
}
