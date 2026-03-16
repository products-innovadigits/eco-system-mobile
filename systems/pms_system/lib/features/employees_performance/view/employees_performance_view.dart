import 'package:pms_system/core/di/pms_locator.dart';
import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/employees_performance/bloc/employees_performance_bloc.dart';
import 'package:pms_system/features/employees_performance/bloc/employees_performance_events.dart';
import 'package:pms_system/features/employees_performance/bloc/employees_performance_states.dart';
import 'package:pms_system/features/employees_performance/model/employees_performance_model.dart';
import 'package:pms_system/features/employees_performance/widgets/performance_podium_section.dart';
import 'package:pms_system/features/employees_performance/widgets/performance_tab_bar.dart';
import 'package:pms_system/features/employees_performance/widgets/top_employees_list.dart';

class EmployeesPerformanceView extends StatefulWidget {
  const EmployeesPerformanceView({super.key});

  @override
  State<EmployeesPerformanceView> createState() =>
      _EmployeesPerformanceViewState();
}

class _EmployeesPerformanceViewState extends State<EmployeesPerformanceView> {
  late EmployeesPerformanceBloc _bloc;
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    _bloc = EmployeesPerformanceBloc(repo: pmsSl())
      ..add(const LoadPerformanceData());
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EmployeesPerformanceBloc>.value(
      value: _bloc,
      child: Scaffold(
        appBar: CustomAppBar(
          title: allTranslations.text(LocaleKeys.performance),
          withCancelBtn: false,
        ),
        body: BlocBuilder<EmployeesPerformanceBloc, EmployeesPerformanceState>(
          builder: (context, state) {
            return switch (state) {
              PerformanceLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
              PerformanceLoaded(:final data) => _PerformanceBody(
                data: data,
                selectedTab: _selectedTab,
                onTabChanged: (index) {
                  setState(() => _selectedTab = index);
                },
              ),
              PerformanceFailure(:final message) => Center(
                child: EmptyContainer(txt: message),
              ),
              _ => const SizedBox.shrink(),
            };
          },
        ),
      ),
    );
  }
}

class _PerformanceBody extends StatelessWidget {
  final EmployeesPerformanceDataModel data;
  final int selectedTab;
  final ValueChanged<int> onTabChanged;

  const _PerformanceBody({
    required this.data,
    required this.selectedTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    final topEmployees = selectedTab == 0
        ? (data.topMonthly ?? [])
        : (data.topYearly ?? []);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16.h),
          PerformanceTabBar(
            selectedIndex: selectedTab,
            onTabChanged: onTabChanged,
          ),
          SizedBox(height: 16.h),
          PerformancePodiumSection(topEmployees: topEmployees),
          SizedBox(height: 24.h),
          TopEmployeesList(employees: data.top10 ?? []),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}
