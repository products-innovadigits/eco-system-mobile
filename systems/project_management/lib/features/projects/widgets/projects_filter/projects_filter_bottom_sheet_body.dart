
import '../../../../core/utility/project_management_exports.dart';

class ProjectsFilterBottomSheetBody extends StatelessWidget {
  const ProjectsFilterBottomSheetBody({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ProjectsFiltrationBloc>();
    return SizedBox(
      height: context.h * 0.65,
      child: ListAnimator(
        separatorPadding: 16.h,
        data: [
          SizedBox(height: 16.h),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                  SizedBox(width: 16.w),
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
            ],
          ),
          CustomFiltersDropList(
            labelText: LocaleKeys.category,
            hintText: LocaleKeys.select_category,
            options: bloc.categoriesList,
            initial: bloc.selectedCategory,
            onSelect: (s) {
              bloc.selectedCategory = s;
            },
          ),
          CustomFiltersDropList(
            labelText: LocaleKeys.status,
            hintText: LocaleKeys.select_status,
            options: bloc.statusList,
            initial: bloc.selectedStatus,
            onSelect: (s) {
              bloc.selectedStatus = s;
            },
          ),
          CustomFiltersDropList(
            labelText: LocaleKeys.risk_level,
            hintText: LocaleKeys.select_risk_level,
            options: bloc.riskList,
            initial: bloc.selectedRisk,
            onSelect: (s) {
              bloc.selectedRisk = s;
            },
          ),
          CustomFiltersDropList(
            labelText: LocaleKeys.priority,
            hintText: LocaleKeys.select_priority,
            options: bloc.priorityList,
            initial: bloc.selectedPriority,
            onSelect: (s) {
              bloc.selectedPriority = s;
            },
          ),
        ],
      ),
    );
  }
}
