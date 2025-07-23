import '../../shared/strategy_exports.dart';

class StrategyHomeBody extends StatelessWidget {
  const StrategyHomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StrategyBloc(),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            spacing: 16.h,
            children: [
              130.sh,
              ObjectivePercentageSection(isStrategyHome: true),
              KpiInitiativesProgressSection(),
              BscCardSection(),
              StrategicAxisCardSection(),
              16.sh,
            ],
          ),
        ),
      ),
    );
  }
}
