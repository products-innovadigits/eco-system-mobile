import 'package:project_management/core/utility/project_management_exports.dart';
import 'package:project_management/shared/components/project_management_system_switcher.dart';
import 'package:project_management/shared/widgets/project_management_bottom_nav_bar.dart';

class ProjectManagementLayout extends StatefulWidget {
  final int index;
  final bool showSwitcher;

  const ProjectManagementLayout({
    super.key,
    this.index = 0,
    this.showSwitcher = false,
  });

  @override
  State<ProjectManagementLayout> createState() =>
      _ProjectManagementLayoutState();
}

class _ProjectManagementLayoutState extends State<ProjectManagementLayout>
    with WidgetsBindingObserver {
  int _index = 0;
  late bool _showSwitcher;

  @override
  void initState() {
    _index = widget.index;
    _showSwitcher = widget.showSwitcher;
    super.initState();
  }

  Widget layout(int index) => switch (index) {
    0 => const ProjectManagementHomeView(),
    1 => const Center(
      child: Text(
        '...Coming Soon',
        style: TextStyle(
          fontSize: FontSizes.f20,
          color: Colors.grey,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    2 => const Center(
      child: Text(
        'لا يوجد إشعارات',
        style: TextStyle(
          fontSize: FontSizes.f20,
          color: Colors.grey,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    _ => SizedBox(),
  };

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Stack(
        children: [
          Scaffold(
            body: layout(_index),
            bottomNavigationBar: ProjectManagementBottomNavBar(
              index: _index,
              onSelect: (p0) {
                _index = p0;
                setState(() {});
              },
            ),
          ),
          if (_showSwitcher)
            ProjectManagementSystemSwitcher(
              onComplete: () {
                setState(() {
                  _showSwitcher = false;
                });
              },
            ),
        ],
      ),
    );
  }
}

class ProjectManagementLayoutArgs {
  final int index;
  final bool showSwitcher;

  const ProjectManagementLayoutArgs({
    this.index = 0,
    this.showSwitcher = false,
  });
}
