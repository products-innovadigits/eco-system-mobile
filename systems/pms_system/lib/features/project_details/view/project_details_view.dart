

import 'package:pms_system/core/utility/pms_exports.dart';

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
              create: (context) =>
                  ProjectDetailsBloc()..add(LoadProjectDetails(projectId: id)),
            ),
            BlocProvider(
              create: (context) => ProjectGeneralProgressSummaryBloc()
                ..add(
                  LoadGeneralProgressSummary(
                    projectId: id,
                    chartType: ChartTime.Month,
                  ),
                ),
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
