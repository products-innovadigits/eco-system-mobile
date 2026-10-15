import 'package:project_management/core/utility/project_management_exports.dart';

/// The fields of the projects and latest request filter sheets: the date
/// range and the category, status, risk and priority dropdowns.
class ProjectFiltersForm extends StatelessWidget {
  final ProjectFiltersSelection filters;

  const ProjectFiltersForm({super.key, required this.filters});

  @override
  Widget build(BuildContext context) {
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
                    child: _DateField(
                      hintKey: LocaleKeys.from,
                      icon: Assets.svgs.calendarFrom.path,
                      controller: filters.pickedStartCtrl,
                      onTap: () => filters.showStartDatePicker(context),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: _DateField(
                      hintKey: LocaleKeys.to,
                      icon: Assets.svgs.calendarTo.path,
                      controller: filters.pickedEndCtrl,
                      onTap: () => filters.showEndDatePicker(context),
                    ),
                  ),
                ],
              ),
            ],
          ),
          CustomFiltersDropList(
            labelText: LocaleKeys.category,
            hintText: LocaleKeys.select_category,
            options: filters.categoriesList,
            initial: filters.selectedCategory,
            onSelect: (option) => filters.selectedCategory = option,
          ),
          CustomFiltersDropList(
            labelText: LocaleKeys.status,
            hintText: LocaleKeys.select_status,
            options: filters.statusList,
            initial: filters.selectedStatus,
            onSelect: (option) => filters.selectedStatus = option,
          ),
          CustomFiltersDropList(
            labelText: LocaleKeys.risk_level,
            hintText: LocaleKeys.select_risk_level,
            options: filters.riskList,
            initial: filters.selectedRisk,
            onSelect: (option) => filters.selectedRisk = option,
          ),
          CustomFiltersDropList(
            labelText: LocaleKeys.priority,
            hintText: LocaleKeys.select_priority,
            options: filters.priorityList,
            initial: filters.selectedPriority,
            onSelect: (option) => filters.selectedPriority = option,
          ),
        ],
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  final String hintKey;
  final String icon;
  final TextEditingController controller;
  final VoidCallback onTap;

  const _DateField({
    required this.hintKey,
    required this.icon,
    required this.controller,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      hint: allTranslations.text(hintKey),
      controller: controller,
      textStyle: context.textTheme.bodySmall?.copyWith(
        fontWeight: FontWeight.w600,
      ),
      suffixWidget: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Images(image: icon),
      ),
      onTap: onTap,
    );
  }
}
