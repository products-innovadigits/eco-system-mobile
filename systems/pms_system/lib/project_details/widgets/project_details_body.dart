import 'package:pms_system/project_details/widgets/project_details_tabs_section.dart';
import 'package:pms_system/project_details/widgets/project_main_info_section.dart';
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
      mainAxisSize: MainAxisSize.min,
      children: [
        // Fixed header content
        ProjectCardContent(project: model, isDetails: true),
        SizedBox(height: 12.h),
        ProjectDetailsTabsSection(),
        SizedBox(height: 16.h),
        // Scrollable content
        Flexible(
          fit: FlexFit.loose,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: _getTabSection(selectedTab, model),
          ),
        ),
      ],
    );
  }
}

Widget _buildShimmerLoading(BuildContext context) => Column(
  children: [
    CustomShimmerContainer(
      height: 130.h,
      padding: EdgeInsets.symmetric(horizontal: 16.h),
    ),
    SizedBox(height: 12.h),
    Divider(color: context.color.outline, thickness: 1.0),
    Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
      child: CustomShimmerContainer(height: context.h * 0.3, width: context.w),
    ),
    Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
      child: CustomShimmerContainer(height: context.h * 0.3, width: context.w),
    ),
  ],
);

Widget _getTabSection(
  ProjectDetailsEnum selectedTab,
  ProjectDetailsModel model,
) {
  return switch (selectedTab) {
    ProjectDetailsEnum.mainInfo => ProjectMainInfoSection(model: model),
    ProjectDetailsEnum.workflow => Container(),
    _ => Container(),
  };
}
