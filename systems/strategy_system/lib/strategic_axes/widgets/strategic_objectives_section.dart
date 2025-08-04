import 'package:core_system/core/utility/export.dart';
import 'package:strategy_system/bsc/model/bsc_model.dart';
import 'package:strategy_system/shared/bloc/bsc_objectives_bloc.dart';
import 'package:strategy_system/strategic_axes/widgets/strategic_objectives_card.dart';

class StrategicObjectivesSection extends StatelessWidget {
  const StrategicObjectivesSection({
    super.key,
    required this.objectivesList,
  });

  final List<ObjectActiveModel> objectivesList;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BscObjectivesBloc(),
      child: ListView.separated(
        padding: EdgeInsets.zero,
        itemCount: objectivesList.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final objective = objectivesList[index];
          return StrategicObjectivesCard(
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
