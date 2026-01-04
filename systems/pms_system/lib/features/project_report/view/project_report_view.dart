import 'package:pms_system/core/utility/pms_exports.dart';

class ProjectReportView extends StatelessWidget {
  const ProjectReportView({super.key, required this.projectId});

  final int projectId;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              ProjectReportCubit()..loadProjectReport(projectId),
        ),
        BlocProvider(
          create: (context) => ProjectGeneralProgressSummaryBloc()
            ..add(
              LoadGeneralProgressSummary(
                projectId: projectId,
                chartType: ChartTime.month,
              ),
            ),
        ),
      ],
      child: Scaffold(
        appBar: CustomAppBar(
          title: allTranslations.text(LocaleKeys.project_report),
          withBottomBorder: false,
          action: BlocBuilder<ProjectReportCubit, ProjectReportState>(
            buildWhen: (previous, current) =>
                (previous is! ProjectReportLoaded &&
                    current is ProjectReportLoaded) ||
                (previous is ProjectReportLoaded &&
                    current is ProjectReportLoaded &&
                    previous.report != current.report),
            builder: (context, state) {
              return state is ProjectReportLoaded
                  ? _ExportButton(
                      onTap: () {
                        LauncherHelper.downloadFiles(
                          filePath: state.report.data?.pdfFileUrl ?? '',
                          context: context,
                        );
                      },
                    )
                  : const SizedBox.shrink();
            },
          ),
        ),
        body: SafeArea(
          child: BlocBuilder<ProjectReportCubit, ProjectReportState>(
            buildWhen: (previous, current) =>
                previous.runtimeType != current.runtimeType,
            builder: (context, state) {
              return switch (state) {
                // Loading
                ProjectReportLoading() => ShimmerCardsList(
                  itemCount: 4,
                  cardHeight: 200,
                ),

                // Loaded
                ProjectReportLoaded(:final report) =>
                  report.data != null
                      ? ProjectReportBody(
                          model: report.data!,
                          projectId: projectId,
                        )
                      : EmptyContainer(),

                // Error or fallback
                _ => EmptyContainer(
                  txt: allTranslations.text(LocaleKeys.something_went_wrong),
                  img: Assets.svgs.error.path,
                ),
              };
            },
          ),
        ),
      ),
    );
  }
}

class _ExportButton extends StatelessWidget {
  final VoidCallback onTap;

  const _ExportButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: context.color.secondary.withValues(alpha: 0.2),
          shape: BoxShape.circle,
          border: Border.all(color: context.color.secondary),
        ),
        child: Images(image: Assets.svgs.download.path),
      ),
    );
  }
}
