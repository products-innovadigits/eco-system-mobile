import 'package:pms_system/project_details/bloc/project_details/project_details_bloc.dart';
import 'package:pms_system/project_details/bloc/project_details/project_details_events.dart';
import 'package:pms_system/project_details/bloc/general_progress/project_general_progress_summary_bloc.dart';
import 'package:pms_system/project_details/bloc/general_progress/project_general_progress_summary_events.dart';
import 'package:pms_system/pms_home/model/kpis_initiatives_progress_model.dart';
import 'package:pms_system/shared/pms_exports.dart';

class ProjectDetailsView extends StatelessWidget {
  const ProjectDetailsView({super.key, required this.id});

  final int id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "", withBottomBorder: false),
      body: SafeArea(
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => ProjectDetailsBloc()
                ..add(LoadProjectDetails(projectId: id)),
            ),
            BlocProvider(
              create: (context) => ProjectGeneralProgressSummaryBloc()
                ..add(LoadGeneralProgressSummary(
                  projectId: id,
                  chartType: ChartTime.Month,
                )),
            ),
          ],
          child: const ProjectDetailsBody(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            CustomNavigator.push(Routes.PROJECT_REPORT, arguments: id),
        backgroundColor: context.color.primary,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(50)),
        ),
        child: Images(
          image: Assets.svgs.chartReport.path,
          width: 20.w,
          height: 20.h,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}
