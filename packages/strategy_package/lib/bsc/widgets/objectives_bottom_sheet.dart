import 'package:core_package/core/utility/export.dart';
import 'package:strategy_package/bsc/model/bsc_model.dart';
import 'package:strategy_package/bsc/widgets/objective_indicators_card_widget.dart';

class ObjectivesBottomSheet extends StatelessWidget {
  const ObjectivesBottomSheet({super.key, required this.objectivesList});

  final List<ObjectActiveModel> objectivesList;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.h * 0.85,
      child: ListView.separated(
        padding: EdgeInsets.zero,
        itemCount: objectivesList.length,
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
