import '../../../shared/strategy_exports.dart';

class ObjectivesFilterBottomSheetBody extends StatelessWidget {
  const ObjectivesFilterBottomSheetBody({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ObjectivesFiltrationBloc>();
    return SizedBox(
      height: context.h * 0.62,
      child: ListAnimator(
        data: [
          SizedBox(height: 16.h),
          CustomFiltersDropList(
            labelText: LocaleKeys.status,
            hintText: LocaleKeys.select_status,
            options: bloc.statusList,
            initial: bloc.selectedStatus,
            onSelect: (s) {
              bloc.selectedStatus = s;
            },
          ),
          SizedBox(height: 16.h),
          CustomFiltersDropList(
            labelText: LocaleKeys.objective_type,
            hintText: LocaleKeys.select_objective_type,
            options: bloc.objectiveTypesList,
            initial: bloc.selectedObjectiveType,
            onSelect: (s) {
              bloc.selectedObjectiveType = s;
            },
          ),
          SizedBox(height: 16.h),
          CustomFiltersDropList(
            labelText: LocaleKeys.axis,
            hintText: LocaleKeys.select_strategic_axis,
            options: bloc.axisList,
            initial: bloc.selectedAxis,
            onSelect: (s) {
              bloc.selectedAxis = s;
            },
          ),
          SizedBox(height: 16.h),
          CustomFiltersDropList(
            labelText: LocaleKeys.perspective,
            hintText: LocaleKeys.select_perspective,
            options: bloc.perspectivesList,
            initial: bloc.selectedPerspective,
            onSelect: (s) {
              bloc.selectedPerspective = s;
            },
          ),
          SizedBox(height: 16.h),
          CustomFiltersDropList(
            labelText: LocaleKeys.organizational_objective,
            hintText: LocaleKeys.select_organizational_objective,
            options: bloc.organizationalObjectivesList,
            initial: bloc.selectedOrganizationalObjective,
            onSelect: (s) {
              bloc.selectedOrganizationalObjective = s;
            },
          ),
        ],
      ),
    );
  }
}
