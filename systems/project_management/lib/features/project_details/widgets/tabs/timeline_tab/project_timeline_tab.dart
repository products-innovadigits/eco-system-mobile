import 'package:project_management/core/utility/project_management_exports.dart';

class ProjectTimelineTab extends StatelessWidget {
  final int projectId;

  /// Project bounds — hints only; the timeline widens its window to fit the
  /// milestones it is given.
  final DateTime? projectStart;
  final DateTime? projectEnd;

  const ProjectTimelineTab({
    super.key,
    required this.projectId,
    this.projectStart,
    this.projectEnd,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectDetailsBloc, ProjectDetailsState>(
      buildWhen: (previous, current) {
        return current is ProjectTimelineLoaded ||
            current is ProjectTimelineLoading ||
            current is ProjectTimelineFailure ||
            current is ProjectDetailsLoaded;
      },
      builder: (context, state) {
        return switch (state) {
          // ── Loading ─────────────────────────
          ProjectTimelineLoading() => CustomShimmerContainer(),

          // ── Done ────────────────────────────
          ProjectTimelineLoaded(:final milestones) =>
            milestones.isEmpty ? const EmptyContainer() : _timeline(milestones),

          // ── ProjectDetailsLoaded state: check for cached milestones ──
          ProjectDetailsLoaded() => () {
            final cachedMilestones = context
                .read<ProjectDetailsBloc>()
                .cachedMilestones;
            if (cachedMilestones == null || cachedMilestones.isEmpty) {
              return const EmptyContainer();
            }
            return _timeline(cachedMilestones);
          }(),

          // ── Error / fallback ────────────────
          _ => EmptyContainer(
            txt: allTranslations.text(LocaleKeys.something_went_wrong),
            img: Assets.svgs.error.path,
            onRetry: () => context.read<ProjectDetailsBloc>().add(
              LoadProjectTimeline(projectId: projectId),
            ),
          ),
        };
      },
    );
  }

  Widget _timeline(List<MilestoneModel> milestones) => ProjectTimeline(
    milestonesList: milestones,
    projectStart: projectStart,
    projectEnd: projectEnd,
  );
}
