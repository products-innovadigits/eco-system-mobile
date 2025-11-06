import 'package:pms_system/shared/pms_exports.dart';

import '../../project_details/bloc/project_general_progress_summary_bloc.dart';

class ProjectReportView extends StatelessWidget {
  const ProjectReportView({super.key, required this.projectId});

  final int projectId;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              ProjectReportBloc()..add(Click(arguments: projectId)),
        ),
        BlocProvider(
          create: (context) =>
              ProjectGeneralProgressSummaryBloc()
                ..add(Click(arguments: projectId)),
        ),
      ],
      child: Scaffold(
        appBar: CustomAppBar(
          title: allTranslations.text(LocaleKeys.project_report),
          withBottomBorder: false,
        ),
        body: SafeArea(
          child: BlocBuilder<ProjectReportBloc, AppState>(
            builder: (context, state) {
              if (state is Loading) {
                return ShimmerCardsList(itemCount: 4, cardHeight: 200);
              } else if (state is Done && state.model is ProjectReportModel) {
                final responseModel = state.model as ProjectReportModel;
                final projectItem = responseModel.data;
                if (projectItem != null) {
                  return ProjectReportBody(model: projectItem , projectId : projectId);
                } else {
                  return EmptyContainer();
                }
              } else {
                return EmptyContainer(
                  txt: allTranslations.text(LocaleKeys.something_went_wrong),
                  img: Assets.svgs.error.path,
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
