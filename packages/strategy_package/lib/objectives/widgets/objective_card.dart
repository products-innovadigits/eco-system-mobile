import '../../shared/strategy_exports.dart';

class ObjectiveCard extends StatelessWidget {
  const ObjectiveCard({super.key, required this.objective});
  final ObjectiveDetailsModel objective;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => CustomNavigator.push(Routes.OBJECTIVE_DETAILS,
          arguments: objective.id),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
            color: context.color.surfaceContainer,
            border: Border.all(color: context.color.outline),
            borderRadius: BorderRadius.circular(12.w)),
        child: ObjectiveCardContent(objective: objective),
      ),
    );
  }
}
