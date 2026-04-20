import 'package:ats_system/bloc/ats_filtration_bloc.dart';
import 'package:ats_system/candidates/bloc/candidates_bloc.dart';
import 'package:ats_system/candidates/view/screens/candidates_view.dart';
import 'package:ats_system/jobs/bloc/jobs_bloc.dart';
import 'package:ats_system/jobs/view/screens/jobs_view.dart';
import 'package:ats_system/jobs/view/sections/available_jobs_section.dart';
import 'package:ats_system/profile/view/screens/profile_view.dart';
import 'package:ats_system/shared/ats_events.dart';
import 'package:ats_system/talent_pool/view/screens/talent_pool_view.dart';
import 'package:ats_system/talent_pool/view/sections/talent_pool_section.dart';
import 'package:core_system/core/config/app_config.dart';
import 'package:core_system/core/modules/home_section.dart';
import 'package:core_system/core/modules/system_module.dart';
import 'package:core_system/core/utility/export.dart'; // BlocProvider, AppEvent/AppState

/// ATS System module implementation.
///
/// Registers all Bloc providers required by the ATS (Applicant Tracking System) module.
class AtsModule implements SystemModule {
  @override
  String get id => 'ats_system';

  @override
  String get name => 'ATS System';

  @override
  ActiveSystemEnum get system => ActiveSystemEnum.ats;

  @override
  List<BlocProvider> get providers => [
    // Jobs Bloc - manages job listings and operations
    BlocProvider<JobsBloc>(
      create: (_) => JobsBloc(),
    ),
    // ATS Filtration Bloc - used for filtering candidates/jobs
    BlocProvider<AtsFiltrationBloc>(create: (_) => AtsFiltrationBloc()),
  ];

  @override
  Map<String, RouteFactory> get routes => {
    Routes.JOBS: (settings) =>
        MaterialPageRoute(settings: settings, builder: (_) => const JobsView()),
    Routes.TALENT_POOL: (settings) => MaterialPageRoute(
      settings: settings,
      builder: (_) => const TalentPoolView(),
    ),
    Routes.PROFILE: (settings) {
      final args = settings.arguments as ProfileViewArgs?;
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => ProfileView(
          isTalent: args?.isTalent ?? false,
          candidateId: args?.candidateId ?? 0,
        ),
      );
    },
    Routes.CANDIDATES: (settings) {
      final args = settings.arguments as InitCandidates?;
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => BlocProvider(
          create: (_) => CandidatesBloc()..add(args ?? InitCandidates()),
          child: Candidates(),
        ),
      );
    },
  };

  @override
  List<HomeSection> get homeSections => [
    HomeSection(
      id: 'available_jobs',
      order: 30, // Positioned after Project Management sections
      builder: (context) {
        if (UserBloc.activeSystems.contains(ActiveSystemEnum.ats) &&
            AppConfig.activeSystem == ActiveSystemEnum.ats) {
          return const AvailableJobsSection();
        }
        return const SizedBox.shrink();
      },
    ),
    HomeSection(
      id: 'talent_pool',
      order: 31,
      builder: (context) {
        if (UserBloc.activeSystems.contains(ActiveSystemEnum.ats) &&
            AppConfig.activeSystem == ActiveSystemEnum.ats) {
          return const TalentPoolSection();
        }
        return const SizedBox.shrink();
      },
    ),
  ];
}
