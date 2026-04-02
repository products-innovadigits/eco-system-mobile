import 'package:core_system/core/modules/home_section.dart';
import 'package:core_system/core/utility/export.dart';
import 'package:eco_system/app/modules/modules_registry.dart';

/// Vertical gap between consecutive home sections (single rhythm for alignment).
double get mainPageSectionGap => 16.h;

/// Whether this section should be built for the current [UserBloc.activeSystems].
/// Keeps spacing correct when a system is off (no [SizedBox.shrink] + gap stack).
bool homeSectionActiveForCurrentUser(HomeSection section) {
  switch (section.id) {
    case 'objective_percentage':
      return UserBloc.activeSystems.contains(ActiveSystemEnum.strategy);
    case 'project_management':
      return UserBloc.activeSystems.contains(
        ActiveSystemEnum.projectManagement,
      );
    case 'pms':
      return UserBloc.activeSystems.contains(ActiveSystemEnum.pms);
    case 'available_jobs':
    case 'talent_pool':
      return UserBloc.activeSystems.contains(ActiveSystemEnum.ats);
    default:
      return true;
  }
}

/// Builds main-page section widgets with uniform vertical gaps between visible sections only.
List<Widget> mainPageSectionWidgets(BuildContext context) {
  final sections = ModulesRegistry.appSections
      .where(homeSectionActiveForCurrentUser)
      .toList();
  if (sections.isEmpty) return [];

  final gap = mainPageSectionGap;
  final out = <Widget>[];
  for (var i = 0; i < sections.length; i++) {
    out.add(sections[i].builder(context));
    if (i < sections.length - 1) {
      out.add(SizedBox(height: gap));
    }
  }
  return out;
}
