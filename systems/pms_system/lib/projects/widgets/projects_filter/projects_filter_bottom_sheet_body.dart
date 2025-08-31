import '../../../shared/pms_exports.dart';

class ProjectsFilterBottomSheetBody extends StatelessWidget {
  const ProjectsFilterBottomSheetBody({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ProjectsFiltrationBloc>();
    return SizedBox(
      height: context.h * 0.52,
      child: ListAnimator(
        data: [
          16.sh,
          CustomFiltersDropList(
            labelText: LocaleKeys.category,
            hintText: LocaleKeys.select_category,
            options: bloc.categoriesList,
            initial: bloc.selectedCategory,
            onSelect: (s) {
              bloc.selectedCategory = s;
            },
          ),
          16.sh,
          CustomFiltersDropList(
            labelText: LocaleKeys.status,
            hintText: LocaleKeys.select_status,
            options: bloc.statusList,
            initial: bloc.selectedStatus,
            onSelect: (s) {
              bloc.selectedStatus = s;
            },
          ),
          16.sh,
          CustomFiltersDropList(
            labelText: LocaleKeys.risk_level,
            hintText: LocaleKeys.select_risk_level,
            options: bloc.riskList,
            initial: bloc.selectedRisk,
            onSelect: (s) {
              bloc.selectedRisk = s;
            },
          ),
          16.sh,
          CustomFiltersDropList(
            labelText: LocaleKeys.priority,
            hintText: LocaleKeys.select_priority,
            options: bloc.priorityList,
            initial: bloc.selectedPriority,
            onSelect: (s) {
              bloc.selectedPriority = s;
            },
          ),
          16.sh,
        ],
      ),
    );
  }
}
