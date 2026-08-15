import 'package:project_management/core/utility/project_management_exports.dart';
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
      child: Text('التقارير', style: TextStyle(fontSize: FontSizes.f32)),
    ),
    2 => const Center(
      child: Text('الإشعارات', style: TextStyle(fontSize: FontSizes.f32)),
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
            floatingActionButton: FloatingActionButton(
              tooltip: allTranslations.text(LocaleKeys.ai_assistant),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.r),
              ),
              heroTag: 'project_management_ai_assistant_fab',
              onPressed: () {
                CustomNavigator.push(Routes.AI_ASSISTANT);
              },
              child: const Icon(Icons.auto_awesome_outlined),
            ),
            bottomNavigationBar: ProjectManagementBottomNavBar(
              index: _index,
              onSelect: (p0) {
                _index = p0;
                setState(() {});
              },
            ),
          ),
          if (_showSwitcher)
            SystemsSwitcher(
              systemEnum: ActiveSystemEnum.projectManagement,
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
