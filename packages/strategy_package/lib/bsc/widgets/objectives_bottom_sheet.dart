import 'package:core_package/core/utility/export.dart';
import 'package:strategy_package/bsc/model/bsc_model.dart';
import 'package:strategy_package/bsc/widgets/objective_indicators_card_widget.dart';

class ObjectivesBottomSheet extends StatelessWidget {
  final bool isStrategicAxis;

  const ObjectivesBottomSheet({
    super.key,
    required this.objectivesList,
    this.isStrategicAxis = false,
  });

  final List<ObjectActiveModel> objectivesList;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: isStrategicAxis ? null : context.h * 0.85,
      child: ListView.separated(
        padding: EdgeInsets.zero,
        itemCount: objectivesList.length,
        shrinkWrap: isStrategicAxis ? true : false,
        physics: isStrategicAxis
            ? const NeverScrollableScrollPhysics()
            : const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final objective = objectivesList[index];
          return ObjectiveIndicatorsCardWidget(
            objectiveTitle: objective.title ?? '',
            initiatives: objective.initiatives ?? [],
            kpis: objective.kpIs ?? [],
            index: index,
          );
        },
        separatorBuilder: (context, index) => SizedBox(height: 12.h),
      ),
    );
  }
}
