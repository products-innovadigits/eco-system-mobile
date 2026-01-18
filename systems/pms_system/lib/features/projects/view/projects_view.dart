import 'package:core_system/core/components/custom_screen_type_layout_widget.dart';
import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/projects/bloc/filtration/projects_filtration_bloc.dart';
import 'package:pms_system/features/projects/bloc/projects/projects_bloc.dart';
import 'package:pms_system/features/projects/bloc/projects/projects_events.dart';
import 'package:pms_system/features/projects/bloc/sorting/projects_sorting_bloc.dart';
import 'package:pms_system/features/projects/widgets/projects_app_bar_widget.dart';
import 'package:pms_system/features/projects/widgets/projects_body_mobile_landscape_view.dart';
import 'package:pms_system/features/projects/widgets/projects_body_mobile_portrait_view.dart';
import 'package:pms_system/shared/widgets/pms_bottom_nav_bar.dart';

class ProjectsView extends StatefulWidget {
  const ProjectsView({super.key});

  @override
  State<ProjectsView> createState() => _ProjectsViewState();
}

class _ProjectsViewState extends State<ProjectsView> {
  int _selectedIndex = 0;
  late ProjectsSortingBloc _sortingBloc;
  late ProjectsBloc _projectsBloc;

  @override
  void initState() {
    super.initState();
    _sortingBloc = ProjectsSortingBloc();
    _projectsBloc = ProjectsBloc(sortingBloc: _sortingBloc)..add(
      LoadProjects(searchEngine: SearchEngine()),
    );

    // Clear filters when entering the view
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ProjectsFiltrationBloc.instance.clearFilters();
      }
    });
  }

  @override
  void dispose() {
    _sortingBloc.close();
    _projectsBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProjectsSortingBloc>.value(value: _sortingBloc),
        BlocProvider<ProjectsBloc>.value(value: _projectsBloc),
      ],
      child: Builder(
        builder: (context) {
          final isPortrait =
              MediaQuery.of(context).orientation == Orientation.portrait;
          return Scaffold(
            appBar: ProjectsAppBarWidget(
              bloc: _projectsBloc,
              sortingBloc: _sortingBloc,
              isPortrait: isPortrait,
            ),
            body: CustomScreenTypeLayoutWidget(
              mobilePortrait: (ctx) => const ProjectsBodyMobilePortraitView(),
              mobileLandscape: (ctx) => const ProjectsBodyMobileLandscapeView(),
            ),
            bottomNavigationBar: PmsBottomNavBar(
              index: _selectedIndex,
              isSubPage: true,
              onSelect: (index) {
                if (_selectedIndex != index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                }
              },
            ),
          );
        },
      ),
    );
  }
}
