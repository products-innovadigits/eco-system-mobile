import 'package:pms_system/pms_home/model/timeline_project_model.dart';
import 'package:pms_system/pms_home/widgets/timeline/timeline_widget.dart';
import 'package:pms_system/project_details/widgets/tabs/project_details_tabs_section.dart';
import 'package:pms_system/project_details/widgets/tabs/project_main_info_tab.dart';
import 'package:pms_system/project_details/widgets/tabs/project_workflow_tab.dart';
import 'package:pms_system/shared/pms_exports.dart';

class ProjectDetailsBody extends StatelessWidget {
  const ProjectDetailsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectDetailsBloc, AppState>(
      builder: (context, state) {
        final selectedTab = context.select(
          (ProjectDetailsBloc bloc) => bloc.selectedTab,
        );
        return switch (state) {
          // ── Loading ─────────────────────────
          Loading() => _buildShimmerLoading(context),

          // ── Done ────────────────────────────
          Done(:final ProjectDetailsModel model) => _ProjectBody(
            model: model,
            selectedTab: selectedTab,
          ),

          // ── Empty ───────────────────────────
          Empty() => const EmptyContainer(),

          // ── Error / fallback ────────────────
          _ => EmptyContainer(
            txt: allTranslations.text(LocaleKeys.something_went_wrong),
            img: Assets.svgs.error.path,
          ),
        };
      },
    );
  }
}

class _ProjectBody extends StatelessWidget {
  final ProjectDetailsModel model;
  final ProjectDetailsEnum selectedTab;

  const _ProjectBody({required this.model, required this.selectedTab});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Fixed header content
        ProjectCardContent(project: model, isDetails: true),
        SizedBox(height: 12.h),
        ProjectDetailsTabsSection(),
        SizedBox(height: 16.h),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Scrollable content
                Flexible(
                  fit: FlexFit.loose,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: _getTabSection(selectedTab, model),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

Widget _buildShimmerLoading(BuildContext context) => Padding(
  padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
  child: Column(
    children: [
      CustomShimmerContainer(height: 130.h),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Divider(color: context.color.outline, thickness: 1.0),
      ),
      CustomShimmerContainer(height: context.h * 0.3, width: context.w),
      CustomShimmerContainer(height: context.h * 0.3, width: context.w),
    ],
  ),
);

Widget _getTabSection(
  ProjectDetailsEnum selectedTab,
  ProjectDetailsModel model,
) {
  return switch (selectedTab) {
    ProjectDetailsEnum.mainInfo => ProjectMainInfoTab(model: model),
    ProjectDetailsEnum.workflow => ProjectWorkflowTab(
      stagesList: model.projectLifeCycle?.projectStages ?? [],
    ),
    _ => ProjectTimeline(
      // canvasHeight: 400,
      // keep true since your layout is RTL
      timelineProjects: [
        ProjectItem(
          startMonth: 1,
          startWeek: 2,
          endMonth: 2,
          endWeek: 3,
          name: 'النشاط الرئيسي 01 – رفع جاهزية مركز عمليات الأمن السيبراني',
          subProjects: [
            ProjectItem(
              startMonth: 1,
              startWeek: 2,
              endMonth: 2,
              endWeek: 3,
              name: 'SA-104 اختبار منصة',
            ),
            ProjectItem(
              startMonth: 1,
              startWeek: 2,
              endMonth: 2,
              endWeek: 3,
              name: 'SA-104 اختبار منصة',
            ),
          ],
        ),
        ProjectItem(
          startMonth: 1,
          startWeek: 1,
          endMonth: 2,
          endWeek: 2,
          name: 'النشاط الرئيسي 01 – رفع جاهزية مركز عمليات الأمن السيبراني',
          subProjects: [
            ProjectItem(
              startMonth: 1,
              startWeek: 2,
              endMonth: 2,
              endWeek: 3,
              name: 'SA-104 اختبار منصة',
            ),
            ProjectItem(
              startMonth: 1,
              startWeek: 2,
              endMonth: 2,
              endWeek: 3,
              name: 'SA-104 اختبار منصة',
            ),
            ProjectItem(
              startMonth: 1,
              startWeek: 2,
              endMonth: 2,
              endWeek: 3,
              name: 'SA-104 اختبار منصة',
            ),
            ProjectItem(
              startMonth: 1,
              startWeek: 2,
              endMonth: 2,
              endWeek: 3,
              name: 'SA-104 اختبار منصة',
            ),
          ],
        ),
        ProjectItem(
          startMonth: 1,
          startWeek: 3,
          endMonth: 3,
          endWeek: 1,
          name: 'النشاط الرئيسى 01 – رفع جاهزية مركز عمليات الأمن ',
        ),
        ProjectItem(
          startMonth: 1,
          startWeek: 3,
          endMonth: 3,
          endWeek: 1,
          name: 'النشاط الرئيسى 01 – رفع جاهزية مركز عمليات الأمن ',
        ),
        ProjectItem(
          startMonth: 3,
          startWeek: 1,
          endMonth: 3,
          endWeek: 4,
          name: 'النشاط الرئيسى 01 – رفع جاهزية مركز عمليات الأمن ',
        ),
        ProjectItem(
          startMonth: 4,
          startWeek: 1,
          endMonth: 5,
          endWeek: 2,
          name: 'النشاط الرئيسى 02 – رفع جاهزية مركز عمليات الأمن ',
        ),
        ProjectItem(
          startMonth: 4,
          startWeek: 1,
          endMonth: 5,
          endWeek: 2,
          name: 'النشاط الرئيسى 02 – رفع جاهزية مركز عمليات الأمن ',
        ),
      ],
    ),
  };
}
