import '../../shared/strategy_exports.dart';

class ObjectiveKPIS extends StatelessWidget {
  const ObjectiveKPIS({super.key});

  @override
  Widget build(BuildContext context) {
    return ObjectiveProgressListSection<ObjectiveKPISBloc, ObjectiveKPIModel>(
      titleKey: 'kpis',
      unitKey: 'scale',
      itemTitle: (kpi) => kpi.kpiTitle,
      itemValue: (kpi) => kpi.value,
    );
  }
}
