import '../../shared/strategy_exports.dart';

class ObjectiveInitiatives extends StatelessWidget {
  const ObjectiveInitiatives({super.key});

  @override
  Widget build(BuildContext context) {
    return ObjectiveProgressListSection<
      ObjectiveInitiativesBloc,
      ObjectiveInitiativeModel
    >(
      titleKey: 'initiatives',
      unitKey: 'criteria',
      itemTitle: (initiative) => initiative.initiativeTitle,
      itemValue: (initiative) => initiative.value,
    );
  }
}
