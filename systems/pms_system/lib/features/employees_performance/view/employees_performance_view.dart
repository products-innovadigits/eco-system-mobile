import 'package:pms_system/core/di/pms_locator.dart';
import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/employees_performance/bloc/employees_performance_bloc.dart';
import 'package:pms_system/features/employees_performance/bloc/employees_performance_events.dart';
import 'package:pms_system/features/employees_performance/bloc/employees_performance_states.dart';
import 'package:pms_system/features/employees_performance/model/employees_performance_model.dart';
import 'package:pms_system/features/employees_performance/widgets/employees_performance_loading_shimmer.dart';
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

  void _onTabChanged(int index) {
    setState(() => _selectedTab = index);
    final type = index == 1 ? 'yearly' : null;
    _bloc.add(LoadPerformanceData(type: type));
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
              PerformanceLoading() => _PerformanceBody(
                top3: const [],
                top10: const [],
                selectedTab: _selectedTab,
                onTabChanged: _onTabChanged,
                isLoading: true,
              ),
              PerformanceLoaded(:final top3, :final top10) =>
                _PerformanceBody(
                  top3: top3,
                  top10: top10,
                  selectedTab: _selectedTab,
                  onTabChanged: _onTabChanged,
                ),
              PerformanceFailure(:final message) => Column(
                children: [
                  _TabBarSection(
                    selectedTab: _selectedTab,
                    onTabChanged: _onTabChanged,
                  ),
                  Expanded(child: Center(child: EmptyContainer(txt: message))),
                ],
              ),
              _ => const SizedBox.shrink(),
            };
          },
        ),
      ),
    );
  }
}

class _TabBarSection extends StatelessWidget {
  final int selectedTab;
  final ValueChanged<int> onTabChanged;

  const _TabBarSection({
    required this.selectedTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 16.h),
      child: PerformanceTabBar(
        selectedIndex: selectedTab,
        onTabChanged: onTabChanged,
      ),
    );
  }
}

class _PerformanceBody extends StatelessWidget {
  final List<PerformanceEmployeeModel> top3;
  final List<PerformanceEmployeeModel> top10;
  final int selectedTab;
  final ValueChanged<int> onTabChanged;
  final bool isLoading;

  const _PerformanceBody({
    required this.top3,
    required this.top10,
    required this.selectedTab,
    required this.onTabChanged,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
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
          if (isLoading) const EmployeesPerformanceLoadingShimmer()
          else ...[
            PerformancePodiumSection(topEmployees: top3),
            SizedBox(height: 24.h),
            TopEmployeesList(employees: top10),
            SizedBox(height: 24.h),
          ],
        ],
      ),
    );
  }
}
