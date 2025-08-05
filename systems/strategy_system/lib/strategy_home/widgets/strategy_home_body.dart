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
          child: _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return const Column(
      spacing: 16,
      children: [
        SizedBox(height: 130),
        ObjectivePercentageSection(isStrategyHome: true),
        BscCardSection(),
        OkrCardSection(),
        KpiInitiativesProgressSection(),
        StrategicAxisCardSection(),
        SizedBox(height: 16),
      ],
    );
  }
}
