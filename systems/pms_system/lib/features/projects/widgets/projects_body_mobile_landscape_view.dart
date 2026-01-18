import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/projects/bloc/projects/projects_bloc.dart';
import 'package:pms_system/features/projects/bloc/projects/projects_events.dart';
import 'package:pms_system/features/projects/bloc/projects/projects_state.dart';
import 'package:pms_system/features/projects/widgets/project_card.dart';

class ProjectsBodyMobileLandscapeView extends StatelessWidget {
  const ProjectsBodyMobileLandscapeView({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ProjectsBloc>();
    return SafeArea(
      child: BlocBuilder<ProjectsBloc, ProjectsState>(
        builder: (context, state) {
          return switch (state) {
            // Loading first page
            ProjectsLoading() => ShimmerCardsList(cardHeight: 200),

            // Handle loaded state with data models
            ProjectsLoaded(:final projects, :final isLoadingMore) => Column(
              children: [
                Expanded(
                  child: ListAnimator(
                    customPadding: EdgeInsets.symmetric(horizontal: 24.w),
                    controller: context.read<ProjectsBloc>().scrollController,
                    data: projects
                        .map((project) => ProjectCard(project: project))
                        .toList(),
                  ),
                ),
                CustomLoading(isTextLoading: true, loading: isLoadingMore),
              ],
            ),

            // Empty
            ProjectsEmpty(:final isInitial) => _HandleEmptyList(
              initial: isInitial,
              bloc: bloc,
            ),

            // Error or fallback
            _ => _HandleErrorState(bloc: bloc),
          };
        },
      ),
    );
  }
}

class _HandleEmptyList extends StatelessWidget {
  final bool? initial;
  final ProjectsBloc bloc;

  const _HandleEmptyList({required this.initial, required this.bloc});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.h * 0.6,
      child: EmptyContainer(
        txt: initial == true
            ? null
            : (bloc.searchTEC != null && bloc.searchTEC!.text.isEmpty)
            ? allTranslations.text(LocaleKeys.no_projects_match_your_filters)
            : '${allTranslations.text(LocaleKeys.no_projects_match)} \' ${bloc.searchTEC!.text} \'',
      ),
    );
  }
}

class _HandleErrorState extends StatelessWidget {
  final ProjectsBloc bloc;

  const _HandleErrorState({required this.bloc});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        bloc.add(const RefreshProjects());
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(height: context.h * 0.6, child: const ErrorContainer()),
      ),
    );
  }
}
