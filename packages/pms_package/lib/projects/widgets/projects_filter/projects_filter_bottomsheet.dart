import 'package:core_package/core/widgets/bottom_sheet_header.dart';
import 'package:pms_package/projects/widgets/projects_filter/projects_filter_bottom_sheet_body.dart';
import 'package:pms_package/projects/widgets/projects_filter/projects_filter_buttons_section.dart';
import 'package:pms_package/shared/pms_exports.dart';

class ProjectsFilterBottomSheet extends StatelessWidget {
  const ProjectsFilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectsFiltrationBloc, AppState>(
      builder: (context, state) {
        final filterBloc = context.read<ProjectsFiltrationBloc>();
        final projectsBloc = context.read<ProjectsBloc>();
        return Stack(
          children: [
            Column(
              children: [
                BottomSheetHeader(
                  title: allTranslations.text(LocaleKeys.candidate),
                ),
                ProjectsFilterBottomSheetBody(),
              ],
            ),
            ProjectsFilterButtonsSection(
              onApplyFilters: () =>
                  filterBloc.applyFilters(projectsBloc: projectsBloc),
              onResetFilters: () =>
                  filterBloc.resetFilters(projectsBloc: projectsBloc),
              isFiltered: filterBloc.isFilterApplied,
            ),
          ],
        );
      },
    );
  }
}
