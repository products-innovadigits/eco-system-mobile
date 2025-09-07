import '../../../shared/pms_exports.dart';

class ProjectsFilterBottomSheetBody extends StatelessWidget {
  const ProjectsFilterBottomSheetBody({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ProjectsFiltrationBloc>();
    return SizedBox(
      height: context.h * 0.62,
      child: ListAnimator(
        data: [
          16.sh,
          Text(allTranslations.text(LocaleKeys.start_date)),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  hint: allTranslations.text(LocaleKeys.from),
                  controller: bloc.pickedStartCtrl,
                  textStyle: context.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  suffixWidget: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Images(image: Assets.svgs.calendarFrom.path),
                  ),
                  onTap: () => bloc.showStartDatePicker(context),
                ),
              ),
              16.sw,
              Expanded(
                child: CustomTextField(
                  hint: allTranslations.text(LocaleKeys.to),
                  controller: bloc.pickedEndCtrl,
                  textStyle: context.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  suffixWidget: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Images(image: Assets.svgs.calendarTo.path),
                  ),
                  onTap: () => bloc.showEndDatePicker(context),
                ),
              ),
            ],
          ),
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
