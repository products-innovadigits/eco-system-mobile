import 'package:core_package/core/utility/export.dart';
import 'package:strategy_package/bsc/model/objectives_model.dart';
import 'package:strategy_package/bsc/widgets/objective_indicators_card_widget.dart';

class ObjectivesBottomSheet extends StatelessWidget {
  const ObjectivesBottomSheet({super.key, required this.object});

  final List<ObjectiveDataModel> object;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.h * 0.85,
      child: ListView.separated(
        padding: EdgeInsets.zero,
        itemCount: object.length,
        itemBuilder: (context, index) {
          final objective = object[index];
          return ObjectiveIndicatorsCardWidget(
            objectiveTitle: objective.title ?? '',
            initiatives: objective.initiatives ?? [],
            kpis: objective.kpis ?? [],
            index: index,
          );
        },
        separatorBuilder: (context, index) => SizedBox(height: 12.h),
      ),
    );
  }
}
