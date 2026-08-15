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
  String get name =>
      allTranslations.text(LocaleKeys.employees_management_system);

  @override
  ActiveSystemEnum get system => ActiveSystemEnum.ats;

  @override
  List<BlocProvider> get providers => [
    // Jobs Bloc - manages job listings and operations
    BlocProvider<JobsBloc>(
      create: (_) => JobsBloc()..add(Click(arguments: SearchEngine())),
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

  /// These sections pair ATS data with Project Management, so they only make
  /// sense when both are compiled in — on top of the usual "is this system on
  /// screen right now" check every module applies.
  bool get _showsSections =>
      ActiveSystem.showsContentFor(system) &&
      ActiveSystem.available.contains(ActiveSystemEnum.projectManagement) &&
      ActiveSystem.available.contains(ActiveSystemEnum.ats);

  @override
  List<HomeSection> get homeSections => [
    HomeSection(
      id: 'available_jobs',
      order: 30, // Positioned after Project Management sections
      builder: (context) {
        if (!_showsSections) return const SizedBox.shrink();
        return const AvailableJobsSection();
      },
    ),
    HomeSection(
      id: 'talent_pool',
      order: 31,
      builder: (context) {
        if (!_showsSections) return const SizedBox.shrink();
        return const TalentPoolSection();
      },
    ),
  ];
}
