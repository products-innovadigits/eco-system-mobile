import 'package:core_system/core/widgets/nav_app.dart';
import 'package:pms_system/projects/bloc/projects_sorting_bloc.dart';
import 'package:pms_system/projects/widgets/projects_app_bar_widget.dart';
import 'package:pms_system/shared/pms_exports.dart';

class ProjectsView extends StatefulWidget {
  const ProjectsView({super.key});

  @override
  State<ProjectsView> createState() => _ProjectsViewState();
}

class _ProjectsViewState extends State<ProjectsView> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Clear filters when entering the view
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ProjectsFiltrationBloc.instance.clearFilters();
      }
    });
  }

  void _handleNavigation(int index) {
    // Handle navigation based on selected index
    switch (index) {
      case 0:
        CustomNavigator.push(Routes.PMS_LAYOUT);
        break;
      case 1:
        /* Navigate to reports */
        break;
      case 2:
        /* Navigate to notifications */
        break;
    }

    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProjectsSortingBloc>(
          create: (context) => ProjectsSortingBloc(),
        ),
        BlocProvider<ProjectsBloc>(
          create: (context) {
            final sortingBloc = context.read<ProjectsSortingBloc>();
            return ProjectsBloc(sortingBloc: sortingBloc)
              ..add(Click(arguments: SearchEngine()));
          },
        ),
      ],
      child: Builder(
        builder: (context) {
          final bloc = context.read<ProjectsBloc>();
          final sortingBloc = context.read<ProjectsSortingBloc>();
          return Scaffold(
            appBar: ProjectsAppBarWidget(
              bloc: bloc,
              sortingBloc: sortingBloc,
            ),
            body: SafeArea(
              child: BlocBuilder<ProjectsBloc, AppState>(
                builder: (context, state) {
                  return switch (state) {
                    // Loading…
                    Loading() => const ShimmerCardsList(),

                    // Handle Done state with data models
                    Done(:final list, :final loading) when list != null => Column(
                      children: [
                        Expanded(
                          child: ListAnimator(
                            customPadding: EdgeInsets.symmetric(horizontal: 16.w),
                            controller: context
                                .read<ProjectsBloc>()
                                .scrollController,
                            data: (list as List<ProjectDetailsModel>)
                                .map((project) => ProjectCard(project: project))
                                .toList(),
                          ),
                        ),
                        CustomLoading(isTextLoading: true, loading: loading),
                      ],
                    ),

                    // Empty
                    Empty(:final initial) => _HandleEmptyList(
                      initial: initial,
                      bloc: bloc,
                    ),

                    // Fallback (in case error occurs or something else)
                    _ => _HandleErrorState(bloc: bloc),
                  };
                },
              ),
            ),
            // ✅ PERFORMANCE OPTIMIZATION: BottomNav outside BlocBuilder
            // Only rebuilds when _selectedIndex changes, not on ProjectsBloc state changes
            bottomNavigationBar: NavApp(
              index: _selectedIndex,
              onSelect: _handleNavigation,
            ),
          );
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
        bloc.add(Refresh());
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(height: context.h * 0.6, child: const ErrorContainer()),
      ),
    );
  }
}
