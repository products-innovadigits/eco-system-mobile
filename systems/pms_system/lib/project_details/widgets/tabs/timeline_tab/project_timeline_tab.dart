import 'dart:developer';

import 'package:pms_system/project_details/widgets/tabs/timeline_tab/timeline_widget.dart';

import '../../../../shared/pms_exports.dart';
import '../../../model/project_timeline_model.dart';

class ProjectTimelineTab extends StatelessWidget {
  final DateTime projectStart;
  final DateTime projectEnd;

  const ProjectTimelineTab({
    super.key,
    required this.projectStart,
    required this.projectEnd,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectDetailsBloc, AppState>(
      buildWhen: (previous, current) {
        return current is GettingDone ||
            current is Getting ||
            current is GettingError ||
            current is Empty ||
            current is Done;
      },
      builder: (context, state) {
        return switch (state) {
          // ── Loading ─────────────────────────
          Getting() => CustomShimmerContainer(),

          // ── Done ────────────────────────────
          GettingDone(data: final List<MilestoneModel> milestones) =>
            ProjectTimeline(
              milestonesList: milestones,
              projectStart: projectStart,
              projectEnd: projectEnd,
            ),

          // ── Done state: check for cached milestones ──
          Done() => () {
            final bloc = context.read<ProjectDetailsBloc>();
            final cachedMilestones = bloc.cachedMilestones;
            if (cachedMilestones != null && cachedMilestones.isNotEmpty) {
              return ProjectTimeline(
                milestonesList: cachedMilestones,
                projectStart: projectStart,
                projectEnd: projectEnd,
              );
            }
            return const EmptyContainer();
          }(),

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
