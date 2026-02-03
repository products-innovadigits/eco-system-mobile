import 'package:project_management/core/utility/pms_exports.dart';

class ProjectDetailsTabsSection extends StatelessWidget {
  final int projectId;
  const ProjectDetailsTabsSection({super.key, required this.projectId});

  static Map<ProjectDetailsEnum, String> tabs = {
    ProjectDetailsEnum.mainInfo: LocaleKeys.main_info,
    ProjectDetailsEnum.workflow: LocaleKeys.workflow,
    ProjectDetailsEnum.timeline: LocaleKeys.timeline,
  };

  @override
  Widget build(BuildContext context) {
    final selectedTab = context.select(
      (ProjectDetailsBloc bloc) => bloc.selectedTab,
    );
    return IntrinsicHeight(
      child: Row(
        children: tabs.keys.map((tab) {
          return Flexible(
            fit: FlexFit.tight,
            child: _TabWrapper(
              title: tabs[tab] ?? '',
              isSelected: selectedTab == tab,
              onTap: () {
                context.read<ProjectDetailsBloc>().add(
                  SelectProjectTab(tab: tab),
                );
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _TabWrapper extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabWrapper({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? context.color.secondary.withValues(alpha: 0.1)
              : context.color.surfaceContainer,
          border: Border(
            bottom: BorderSide(
              color: isSelected
                  ? context.color.secondary
                  : context.color.outline,
              width: isSelected ? 2 : 1,
            ),
          ),
        ),
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          style: context.textTheme.labelSmall!.copyWith(
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected
                ? context.color.secondary
                : context.color.outlineVariant,
          ),
          child: Text(allTranslations.text(title), textAlign: TextAlign.center),
        ),
      ),
    );
  }
}
