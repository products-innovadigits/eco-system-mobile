import 'package:ats_system/jobs/view/sections/available_jobs_section.dart';
import 'package:ats_system/talent_pool/view/sections/talent_pool_section.dart';
import 'package:core_system/core/modules/home_section.dart';
import 'package:core_system/core/utility/export.dart';

/// ATS home sections for the app shell ([ModulesRegistry]) and [AtsHomeView] — single source of truth.
List<HomeSection> buildAtsShellHomeSections() {
  final sections = <HomeSection>[
    HomeSection(
      id: 'available_jobs',
      order: 30,
      builder: (context) {
        if (UserBloc.activeSystems.contains(ActiveSystemEnum.ats)) {
          return const AvailableJobsSection();
        }
        return const SizedBox.shrink();
      },
    ),
    HomeSection(
      id: 'talent_pool',
      order: 31,
      builder: (context) {
        if (UserBloc.activeSystems.contains(ActiveSystemEnum.ats)) {
          return const TalentPoolSection();
        }
        return const SizedBox.shrink();
      },
    ),
  ];
  sections.sort((a, b) => a.order.compareTo(b.order));
  return sections;
}
