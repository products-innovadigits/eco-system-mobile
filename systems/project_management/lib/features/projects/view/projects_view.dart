import 'package:core_system/core/components/custom_screen_type_layout_widget.dart';
import 'package:project_management/core/di/project_management_locator.dart';
import 'package:project_management/core/utility/project_management_exports.dart';
import 'package:project_management/features/projects/bloc/filtration/projects_filter_provider.dart';
// import 'package:project_management/shared/widgets/project_management_bottom_nav_bar.dart';

class ProjectsView extends StatefulWidget {
  const ProjectsView({super.key});

  @override
  State<ProjectsView> createState() => _ProjectsViewState();
}

class _ProjectsViewState extends State<ProjectsView> {
  // int _selectedIndex = 0;
  late ProjectsSortingBloc _sortingBloc;
  ProjectsBloc? _projectsBloc;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  bool _blocInitialized = false;

  @override
  void initState() {
    super.initState();
    _sortingBloc = ProjectsSortingBloc(repo: projectManagementSl());
    _scrollController.addListener(_onScroll);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_blocInitialized) {
      _blocInitialized = true;
      final filtrationBloc = context.read<ProjectsFiltrationBloc>();
      final filterProvider = ProjectsFiltrationBlocFilterProvider(
        filtrationBloc,
      );
      _projectsBloc = ProjectsBloc(
        repo: projectManagementSl(),
        sortingBloc: _sortingBloc,
        filterProvider: filterProvider,
      )..add(LoadProjects(searchEngine: SearchEngine()));

      // Clear filters when entering the view
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          filtrationBloc.clearFilters();
        }
      });
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _projectsBloc?.add(const LoadMoreProjects());
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    _sortingBloc.close();
    _projectsBloc?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final projectsBloc = _projectsBloc;
    if (projectsBloc == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider<ProjectsSortingBloc>.value(value: _sortingBloc),
        BlocProvider<ProjectsBloc>.value(value: projectsBloc),
      ],
      child: Builder(
        builder: (context) {
          final isPortrait =
              MediaQuery.of(context).orientation == Orientation.portrait;
          return Scaffold(
            appBar: ProjectsAppBarWidget(
              bloc: projectsBloc,
              sortingBloc: _sortingBloc,
              searchController: _searchController,
              isPortrait: isPortrait,
            ),
            body: CustomScreenTypeLayoutWidget(
              mobilePortrait: (ctx) => ProjectsBodyMobilePortraitView(
                scrollController: _scrollController,
                searchController: _searchController,
              ),
              mobileLandscape: (ctx) => ProjectsBodyMobileLandscapeView(
                scrollController: _scrollController,
                searchController: _searchController,
              ),
            ),
            // bottomNavigationBar: ProjectManagementBottomNavBar(
            //   index: _selectedIndex,
            //   isSubPage: true,
            //   onSelect: (index) {
            //     if (_selectedIndex != index) {
            //       setState(() {
            //         _selectedIndex = index;
            //       });
            //     }
            //   },
            // ),
          );
        },
      ),
    );
  }
}
