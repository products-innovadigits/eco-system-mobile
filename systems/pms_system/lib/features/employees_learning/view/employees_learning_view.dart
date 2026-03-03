import 'package:core_system/core/components/custom_screen_type_layout_widget.dart';
import 'package:pms_system/core/di/pms_locator.dart';
import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/employees_learning/bloc/employees_learning_bloc.dart';
import 'package:pms_system/features/employees_learning/bloc/employees_learning_events.dart';
import 'package:pms_system/features/employees_learning/bloc/filtration/employees_filter_provider.dart';
import 'package:pms_system/features/employees_learning/bloc/filtration/employees_filtration_bloc.dart';
import 'package:pms_system/features/employees_learning/widgets/employees_app_bar_widget.dart';
import 'package:pms_system/features/employees_learning/widgets/employees_body_mobile_landscape_view.dart';
import 'package:pms_system/features/employees_learning/widgets/employees_body_mobile_portrait_view.dart';

class EmployeesLearningView extends StatefulWidget {
  const EmployeesLearningView({super.key});

  @override
  State<EmployeesLearningView> createState() => _EmployeesLearningViewState();
}

class _EmployeesLearningViewState extends State<EmployeesLearningView> {
  late EmployeesFiltrationBloc _filtrationBloc;
  EmployeesLearningBloc? _employeesBloc;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  bool _blocInitialized = false;

  @override
  void initState() {
    super.initState();
    _filtrationBloc = EmployeesFiltrationBloc(repo: pmsSl());
    _scrollController.addListener(_onScroll);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_blocInitialized) {
      _blocInitialized = true;
      final filterProvider =
          EmployeesFiltrationBlocFilterProvider(_filtrationBloc);
      _employeesBloc = EmployeesLearningBloc(
        repo: pmsSl(),
        filterProvider: filterProvider,
      )..add(LoadEmployees(searchEngine: SearchEngine()));

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _filtrationBloc.clearFilters();
        }
      });
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _employeesBloc?.add(const LoadMoreEmployees());
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    _filtrationBloc.close();
    _employeesBloc?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final employeesBloc = _employeesBloc;
    if (employeesBloc == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider<EmployeesFiltrationBloc>.value(value: _filtrationBloc),
        BlocProvider<EmployeesLearningBloc>.value(value: employeesBloc),
      ],
      child: Builder(
        builder: (context) {
          final isPortrait =
              MediaQuery.of(context).orientation == Orientation.portrait;
          return Scaffold(
            appBar: EmployeesAppBarWidget(
              bloc: employeesBloc,
              searchController: _searchController,
              isPortrait: isPortrait,
            ),
            body: CustomScreenTypeLayoutWidget(
              mobilePortrait: (ctx) => EmployeesBodyMobilePortraitView(
                scrollController: _scrollController,
                searchController: _searchController,
              ),
              mobileLandscape: (ctx) => EmployeesBodyMobileLandscapeView(
                scrollController: _scrollController,
                searchController: _searchController,
              ),
            ),
          );
        },
      ),
    );
  }
}
