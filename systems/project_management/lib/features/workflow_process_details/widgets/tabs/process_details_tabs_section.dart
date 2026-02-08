import 'package:project_management/core/utility/project_management_exports.dart';

class ProcessDetailsTabsSection extends StatelessWidget {
  const ProcessDetailsTabsSection({super.key});

  static Map<ProcessTabsEnum, String> tabs = {
    ProcessTabsEnum.followProcess: LocaleKeys.follow_process,
    ProcessTabsEnum.stageDocs: LocaleKeys.current_step_docs,
    // ProcessTabsEnum.fields: LocaleKeys.fields,
    ProcessTabsEnum.history: LocaleKeys.history,
    ProcessTabsEnum.actions: LocaleKeys.actions,
  };

  @override
  Widget build(BuildContext context) {
    final selectedTab = context.select(
      (ProcessDetailsBloc bloc) => bloc.selectedTab,
    );
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsetsDirectional.only(start: 16.0),
        child: Row(
          children: tabs.keys.map((tab) {
            return _TabWrapper(
              title: tabs[tab] ?? '',
              isSelected: selectedTab == tab,
              onTap: () {
                context.read<ProcessDetailsBloc>().add(
                  SelectProcessTab(tab: tab),
                );
              },
            );
          }).toList(),
        ),
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
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        margin: const EdgeInsetsDirectional.only(end: 8),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(25)),
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
            fontSize: FontSizes.f10,
          ),
          child: Text(allTranslations.text(title), textAlign: TextAlign.center),
        ),
      ),
    );
  }
}
