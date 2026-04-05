import 'package:core_system/core/helpers/font_sizes.dart';
import 'package:core_system/core/utility/export.dart';
import 'package:core_system/core/widgets/nav_app.dart';
import 'package:core_system/features/settings/view/settings_view.dart';
import 'package:pms_system/core/di/pms_locator.dart';
import 'package:pms_system/features/employees_learning/bloc/employees_learning_bloc.dart';
import 'package:pms_system/features/employees_learning/bloc/employees_learning_events.dart';
import 'package:pms_system/shared/components/pms_system_switcher.dart';

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

  @override
  void initState() {
    _index = widget.index;
    _showSwitcher = widget.showSwitcher;
    _employeesLearningBloc = EmployeesLearningBloc(repo: pmsSl())
      ..add(LoadEmployees(searchEngine: SearchEngine()));
    super.initState();
  }

  @override
  void dispose() {
    _employeesLearningBloc.close();
    super.dispose();
  }

  Widget layout(int index) => switch (index) {
    0 => const PmsHomeView(),
    1 => const Center(
      child: Text('التقارير', style: TextStyle(fontSize: FontSizes.f32)),
    ),
    2 => const SettingsView(),
    _ => SizedBox(),
  };

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EmployeesLearningBloc>.value(
      value: _employeesLearningBloc,
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
              PmsSystemSwitcher(
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
