import 'package:project_management/core/utility/project_management_exports.dart';

/// Full-screen sizing. Tune these to trade readability against how much of the
/// project fits on screen at once.
const double kFullscreenWeekWidth = 52;
const double kFullscreenRowHeight = 28;
const int kFullscreenBaseRowCount = 8;
const TimelineLaneMetrics kFullscreenLaneMetrics = TimelineLaneMetrics(
  scale: 1.2,
);

/// The timeline on its own screen, forced to landscape.
///
/// The grid sizes its columns from the width it is given, so the extra width of
/// a rotated screen is spent on wider week cells — a short project stops
/// scrolling entirely, and a long one shows far more of itself at once.
class ProjectTimelineFullscreenView extends StatefulWidget {
  final List<MilestoneModel> milestones;
  final DateTime? projectStart;
  final DateTime? projectEnd;

  const ProjectTimelineFullscreenView({
    super.key,
    required this.milestones,
    this.projectStart,
    this.projectEnd,
  });

  static Future<void> open(
    BuildContext context, {
    required List<MilestoneModel> milestones,
    DateTime? projectStart,
    DateTime? projectEnd,
  }) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ProjectTimelineFullscreenView(
          milestones: milestones,
          projectStart: projectStart,
          projectEnd: projectEnd,
        ),
      ),
    );
  }

  @override
  State<ProjectTimelineFullscreenView> createState() =>
      _ProjectTimelineFullscreenViewState();
}

class _ProjectTimelineFullscreenViewState
    extends State<ProjectTimelineFullscreenView> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    // Reclaim the status and navigation bars for the grid.
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    // In dispose rather than in the close button: the screen also leaves on a
    // back gesture or a hardware back press, and it must never strand the app
    // in landscape.
    _restoreOrientation();
    super.dispose();
  }

  void _restoreOrientation() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    // Going straight back to `values` leaves iOS in landscape until the device
    // is physically rotated, so pin portrait through the rotation first and
    // hand control back once it has settled.
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    Future.delayed(const Duration(milliseconds: 400), () {
      SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.color.surface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: TimelineScaleButton(
                  icon: Icons.fullscreen_exit,
                  label: allTranslations.text(LocaleKeys.exit_full_screen),
                  onTap: () => Navigator.of(context).maybePop(),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                child: ProjectTimeline(
                  milestonesList: widget.milestones,
                  projectStart: widget.projectStart,
                  projectEnd: widget.projectEnd,
                  // A rotated screen is for reading the timeline, so spend the
                  // extra room on bigger cells and lanes rather than on more
                  // empty grid. Long projects still scroll, just legibly.
                  minWeekWidth: kFullscreenWeekWidth,
                  rowHeightPx: kFullscreenRowHeight,
                  laneMetrics: kFullscreenLaneMetrics,
                  baseRowCount: kFullscreenBaseRowCount,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Enter / leave full screen control shown above the timeline grid.
class TimelineScaleButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const TimelineScaleButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // No tooltip: the label is already on the button.
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: context.color.secondary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: context.color.secondary.withValues(alpha: 0.4),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: context.color.secondary),
            const SizedBox(width: 6),
            // Flexible: the label is a translation, so its length is not ours
            // to assume — and a missing key renders a long placeholder.
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.labelSmall?.copyWith(
                  color: context.color.secondary,
                  fontWeight: FontWeight.w600,
                  fontSize: FontSizes.f10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
