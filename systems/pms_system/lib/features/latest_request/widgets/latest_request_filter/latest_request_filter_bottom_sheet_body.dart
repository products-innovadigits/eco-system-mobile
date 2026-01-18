import 'package:pms_system/features/latest_request/bloc/filtration/latest_request_filtration_cubit.dart';

import '../../../../core/utility/pms_exports.dart';

class LatestRequestFilterBottomSheetBody extends StatelessWidget {
  const LatestRequestFilterBottomSheetBody({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LatestRequestFiltrationCubit>();
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
                      controller: cubit.pickedStartCtrl,
                      textStyle: context.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      suffixWidget: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Images(image: Assets.svgs.calendarFrom.path),
                      ),
                      onTap: () => cubit.showStartDatePicker(context),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: CustomTextField(
                      hint: allTranslations.text(LocaleKeys.to),
                      controller: cubit.pickedEndCtrl,
                      textStyle: context.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      suffixWidget: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Images(image: Assets.svgs.calendarTo.path),
                      ),
                      onTap: () => cubit.showEndDatePicker(context),
                    ),
                  ),
                ],
              ),
            ],
          ),
          CustomFiltersDropList(
            labelText: LocaleKeys.category,
            hintText: LocaleKeys.select_category,
            options: cubit.categoriesList,
            initial: cubit.selectedCategory,
            onSelect: (s) {
              cubit.selectedCategory = s;
            },
          ),
          CustomFiltersDropList(
            labelText: LocaleKeys.status,
            hintText: LocaleKeys.select_status,
            options: cubit.statusList,
            initial: cubit.selectedStatus,
            onSelect: (s) {
              cubit.selectedStatus = s;
            },
          ),
          CustomFiltersDropList(
            labelText: LocaleKeys.risk_level,
            hintText: LocaleKeys.select_risk_level,
            options: cubit.riskList,
            initial: cubit.selectedRisk,
            onSelect: (s) {
              cubit.selectedRisk = s;
            },
          ),
          CustomFiltersDropList(
            labelText: LocaleKeys.priority,
            hintText: LocaleKeys.select_priority,
            options: cubit.priorityList,
            initial: cubit.selectedPriority,
            onSelect: (s) {
              cubit.selectedPriority = s;
            },
          ),
        ],
      ),
    );
  }
}
