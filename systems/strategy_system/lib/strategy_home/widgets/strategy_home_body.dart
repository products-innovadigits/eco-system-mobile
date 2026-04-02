import 'package:strategy_system/strategy_home/widgets/okr_card_section.dart';

import '../../shared/strategy_exports.dart';

class StrategyHomeBody extends StatelessWidget {
  const StrategyHomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: BlocProvider<StrategyBloc>(
          create: (_) => StrategyBloc(),
          child: _buildContent(context),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 16.h,
      children: [
        SizedBox(height: 70.h),
        const ObjectivePercentageSection(isStrategyHome: true),
        const BscCardSection(),
        const OkrCardSection(),
        const KpiInitiativesProgressSection(),
        const StrategicAxisCardSection(),
        SizedBox(height: 16.h),
      ],
    );
  }
}
