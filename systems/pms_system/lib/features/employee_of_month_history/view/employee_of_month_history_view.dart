import 'package:core_system/core/components/custom_screen_type_layout_widget.dart';
import 'package:pms_system/core/di/pms_locator.dart';
import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/employee_of_month_history/bloc/employee_of_month_history_bloc.dart';
import 'package:pms_system/features/employee_of_month_history/bloc/employee_of_month_history_events.dart';
import 'package:pms_system/features/employee_of_month_history/bloc/filtration/employee_of_month_history_filter_provider.dart';
import 'package:pms_system/features/employee_of_month_history/bloc/filtration/employee_of_month_history_filtration_bloc.dart';
import 'package:pms_system/features/employee_of_month_history/widgets/employee_of_month_history_body_mobile_landscape_view.dart';
import 'package:pms_system/features/employee_of_month_history/widgets/employee_of_month_history_body_mobile_portrait_view.dart';

class EmployeeOfMonthHistoryView extends StatefulWidget {
  const EmployeeOfMonthHistoryView({super.key});

  @override
  State<EmployeeOfMonthHistoryView> createState() =>
      _EmployeeOfMonthHistoryViewState();
}

class _EmployeeOfMonthHistoryViewState
    extends State<EmployeeOfMonthHistoryView> {
  late EmployeeOfMonthHistoryFiltrationBloc _filtrationBloc;
  EmployeeOfMonthHistoryBloc? _historyBloc;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  bool _blocInitialized = false;

  @override
  void initState() {
    super.initState();
    _filtrationBloc = EmployeeOfMonthHistoryFiltrationBloc(repo: pmsSl());
    _scrollController.addListener(_onScroll);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_blocInitialized) {
      _blocInitialized = true;
      final filterProvider = EmployeeOfMonthHistoryFiltrationBlocFilterProvider(
        _filtrationBloc,
      );
      _historyBloc = EmployeeOfMonthHistoryBloc(
        repo: pmsSl(),
        filterProvider: filterProvider,
      )..add(LoadEmployeeOfMonthHistory(searchEngine: SearchEngine()));

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
      _historyBloc?.add(const LoadMoreEmployeeOfMonthHistory());
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    _filtrationBloc.close();
    _historyBloc?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final historyBloc = _historyBloc;
    if (historyBloc == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider<EmployeeOfMonthHistoryFiltrationBloc>.value(
          value: _filtrationBloc,
        ),
        BlocProvider<EmployeeOfMonthHistoryBloc>.value(value: historyBloc),
      ],
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: CustomAppBar(
              title: allTranslations.text(
                LocaleKeys.employee_of_the_month_history,
              ),
            ),
            body: CustomScreenTypeLayoutWidget(
              mobilePortrait: (ctx) =>
                  EmployeeOfMonthHistoryBodyMobilePortraitView(
                    scrollController: _scrollController,
                    searchController: _searchController,
                  ),
              mobileLandscape: (ctx) =>
                  EmployeeOfMonthHistoryBodyMobileLandscapeView(
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
