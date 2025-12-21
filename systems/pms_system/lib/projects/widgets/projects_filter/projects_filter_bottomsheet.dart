import 'package:pms_system/projects/widgets/projects_filter/projects_filter_bottom_sheet_body.dart';
import 'package:pms_system/projects/widgets/projects_filter/projects_filter_buttons_section.dart';
import 'package:pms_system/shared/pms_exports.dart';

class ProjectsFilterBottomSheet extends StatelessWidget {
  const ProjectsFilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectsFiltrationBloc, AppState>(
      buildWhen: (previous, current) =>
          previous.runtimeType != current.runtimeType,
      builder: (context, state) {
        final filterBloc = context.read<ProjectsFiltrationBloc>();
        final projectsBloc = context.read<ProjectsBloc>();
        return Stack(
          children: [
            state is Loading
                ? const ShimmerCardsList(
                    itemCount: 4,
                    cardHeight: 50,
                    listPadding: 0,
                  )
                : const ProjectsFilterBottomSheetBody(),
            if (state is Done)
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
