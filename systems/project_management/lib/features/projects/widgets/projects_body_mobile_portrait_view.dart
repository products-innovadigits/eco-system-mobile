import 'package:project_management/core/utility/project_management_exports.dart';

class ProjectsBodyMobilePortraitView extends StatelessWidget {
  final ScrollController scrollController;
  final TextEditingController searchController;

  const ProjectsBodyMobilePortraitView({
    super.key,
    required this.scrollController,
    required this.searchController,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ProjectsBloc>();
    return SafeArea(
      child: BlocBuilder<ProjectsBloc, ProjectsState>(
        builder: (context, state) {
          return switch (state) {
            // Loading first page
            ProjectsLoading() => const ShimmerCardsList(),

            // Handle loaded state with data models
            ProjectsLoaded(:final projects, :final isLoadingMore) => Column(
              children: [
                Expanded(
                  child: ListAnimator(
                    customPadding: EdgeInsets.symmetric(horizontal: 16.w),
                    controller: scrollController,
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
              searchController: searchController,
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
  final TextEditingController searchController;
  final ProjectsBloc bloc;

  const _HandleEmptyList({
    required this.initial,
    required this.searchController,
    required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.h * 0.6,
      child: EmptyContainer(
        txt: initial == true
            ? null
            : searchController.text.isEmpty
            ? allTranslations.text(LocaleKeys.no_projects_match_your_filters)
            : '${allTranslations.text(LocaleKeys.no_projects_match)} \' ${searchController.text} \'',
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
