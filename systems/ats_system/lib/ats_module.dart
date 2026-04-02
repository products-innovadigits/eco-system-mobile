import 'package:ats_system/ats_layout.dart';
import 'package:ats_system/ats_shell_home_sections.dart';
import 'package:ats_system/bloc/ats_filtration_bloc.dart';
import 'package:ats_system/candidates/bloc/candidates_bloc.dart';
import 'package:ats_system/candidates/view/screens/candidates_view.dart';
import 'package:ats_system/jobs/bloc/jobs_bloc.dart';
import 'package:ats_system/jobs/view/screens/jobs_view.dart';
import 'package:ats_system/profile/view/screens/profile_view.dart';
import 'package:ats_system/shared/ats_events.dart';
import 'package:ats_system/talent_pool/view/screens/talent_pool_view.dart';
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
      create: (_) => JobsBloc()..add(Click(arguments: SearchEngine())),
    ),
    // ATS Filtration Bloc - used for filtering candidates/jobs
    BlocProvider<AtsFiltrationBloc>(create: (_) => AtsFiltrationBloc()),
  ];

  @override
  Map<String, RouteFactory> get routes => {
    Routes.ATS_LAYOUT: (settings) {
      final args = settings.arguments as AtsLayoutArgs? ??
          const AtsLayoutArgs(showSwitcher: true);
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => AtsLayout(
          index: args.index,
          showSwitcher: args.showSwitcher,
        ),
      );
    },
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
  List<HomeSection> get homeSections => buildAtsShellHomeSections();
}

