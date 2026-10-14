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
        SizedBox(height: 80),
        ObjectivePercentageSection(isStrategyHome: true),
        BscCardSection(),
        OkrCardSection(),
        // Hidden: renders hardcoded mock objectives/KPI/initiative values, so
        // it shows progress even for objectives with no linked initiatives or
        // indicators. Restore once the backend exposes a dashboard endpoint
        // (per objective: name, kpisValue, initiativesValue, objectiveValue,
        // and initiative/KPI counts so unlinked objectives can be shown empty).
        // KpiInitiativesProgressSection(),
        StrategicAxisCardSection(),
        SizedBox(height: 16),
      ],
    );
  }
}
