import 'package:core_system/core/helpers/font_sizes.dart';
import 'package:core_system/core/utility/export.dart';
import 'package:core_system/core/widgets/nav_app.dart';
import 'package:pms_system/core/di/pms_locator.dart';
import 'package:pms_system/features/employees_learning/bloc/employees_learning_bloc.dart';
import 'package:pms_system/features/employees_learning/bloc/employees_learning_events.dart';
import 'package:pms_system/features/employees_performance/bloc/employees_performance_bloc.dart';
import 'package:pms_system/features/employees_performance/bloc/employees_performance_events.dart';

import 'features/pms_home/view/pms_home_view.dart';

class PmsLayout extends StatefulWidget {
  final int index;
  final bool showSwitcher;

  const PmsLayout({super.key, this.index = 0, this.showSwitcher = false});

  @override
  State<PmsLayout> createState() => _PmsLayoutState();
}

class _PmsLayoutState extends State<PmsLayout> with WidgetsBindingObserver {
  int _index = 0;
  late bool _showSwitcher;
  late final EmployeesLearningBloc _employeesLearningBloc;
  late final EmployeesPerformanceBloc _employeesPerformanceBloc;

  @override
  void initState() {
    _index = widget.index;
    _showSwitcher = widget.showSwitcher;
    _employeesLearningBloc = EmployeesLearningBloc(repo: pmsSl())
      ..add(LoadEmployees(searchEngine: SearchEngine()));
    _employeesPerformanceBloc = EmployeesPerformanceBloc(repo: pmsSl())
      ..add(const LoadPerformanceData());
    super.initState();
  }

  @override
  void dispose() {
    _employeesLearningBloc.close();
    _employeesPerformanceBloc.close();
    super.dispose();
  }

  Widget layout(int index) => switch (index) {
    0 => const PmsHomeView(),
    1 => const Center(
      child: Text('التقارير', style: TextStyle(fontSize: FontSizes.f32)),
    ),
    2 => const Center(
      child: Text('الإشعارات', style: TextStyle(fontSize: FontSizes.f32)),
    ),
    _ => SizedBox(),
  };

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<EmployeesLearningBloc>.value(
          value: _employeesLearningBloc,
        ),
        BlocProvider<EmployeesPerformanceBloc>.value(
          value: _employeesPerformanceBloc,
        ),
      ],
      child: PopScope(
        canPop: false,
        child: Stack(
          children: [
            Scaffold(
              body: layout(_index),
              bottomNavigationBar: NavApp(
                index: _index,
                onSelect: (p0) {
                  _index = p0;
                  setState(() {});
                },
              ),
            ),
            if (_showSwitcher)
              SystemsSwitcher(
                systemEnum: ActiveSystemEnum.pms,
                onComplete: () {
                  setState(() {
                    _showSwitcher = false;
                  });
                },
              ),
          ],
        ),
      ),
    );
  }
}

class PmsLayoutArgs {
  final int index;
  final bool showSwitcher;

  const PmsLayoutArgs({this.index = 0, this.showSwitcher = false});
}
