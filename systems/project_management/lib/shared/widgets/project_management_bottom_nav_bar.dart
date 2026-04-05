import 'package:core_system/core/widgets/nav_app.dart';
import 'package:project_management/core/utility/project_management_exports.dart';

class ProjectManagementBottomNavBar extends StatelessWidget {
  final int index;
  final Function(int)? onSelect;
  final bool isSubPage;

  const ProjectManagementBottomNavBar({
    super.key,
    required this.index,
    this.onSelect,
    this.isSubPage = false,
  });

  @override
  Widget build(BuildContext context) {
    return NavApp(
      index: index,
      onSelect: (value) {
        if (onSelect != null) {
          onSelect!(value);
        }

        if (isSubPage) {
          _handleSubPageNavigation(value);
        }
      },
    );
  }

  void _handleSubPageNavigation(int value) {
    switch (value) {
      case 0:
        CustomNavigator.push(Routes.PROJECT_MANAGEMENT_LAYOUT);
        break;
      case 1:
        // Navigate to reports if needed
        break;
      case 2:
        CustomNavigator.push(Routes.SETTINGS);
        break;
    }
  }
}
