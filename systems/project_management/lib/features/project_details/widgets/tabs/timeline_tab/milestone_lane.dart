import 'package:project_management/core/utility/project_management_exports.dart';

/// Renders one milestone bar and its sub-activity chips inside the lane the
/// layout pass reserved for them.
///
/// All date math is done once during layout ([PlacedMilestone]); this widget
/// only turns column offsets into pixels, using the same [TimelineLaneMetrics]
/// the layout reserved the band height from.
class MilestoneLane extends StatelessWidget {
  final PlacedMilestone placed;
  final double weekWidth;
  final bool isRTL;
  final TimelineLaneMetrics metrics;
  final void Function(MilestoneModel milestone)? onMilestoneTap;
  final void Function(SubActivityModel subactivity)? onSubactivityTap;

  const MilestoneLane({
    super.key,
    required this.placed,
    required this.weekWidth,
    required this.isRTL,
    this.metrics = const TimelineLaneMetrics(),
    this.onMilestoneTap,
    this.onSubactivityTap,
  });

  /// Distance from the lane's leading edge, in pixels.
  double _leftOf(double startOffset, double endOffset) => isRTL
      ? (placed.laneEndOffset - endOffset) * weekWidth
      : (startOffset - placed.laneStartOffset) * weekWidth;

  @override
  Widget build(BuildContext context) {
    final TextStyle? milestoneLabelStyle = context.textTheme.labelMedium
        ?.copyWith(
          fontWeight: FontWeight.w600,
          color: context.color.secondary,
          fontSize: metrics.labelFontSize,
        );
    final TextStyle? subactivityLabelStyle = context.textTheme.labelSmall
        ?.copyWith(
          fontWeight: FontWeight.w700,
          color: context.color.tertiaryContainer,
          fontSize: metrics.labelFontSize,
        );

    final String milestoneName = placed.milestone.name ?? '';
    final double barWidth =
        (placed.barEndOffset - placed.barStartOffset) * weekWidth;
    final double dotSize = metrics.dotRadius * 2;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // ===== Milestone bar (blue) =====
        Positioned(
          top: 0,
          left: _leftOf(placed.barStartOffset, placed.barEndOffset),
          width: barWidth,
          height: metrics.barHeight,
          child: TimelineLabelTooltip(
            message: milestoneName,
            details: formatTimelineDateRange(
              placed.milestone.startDate,
              placed.milestone.endDate,
            ),
            availableWidth:
                barWidth - (metrics.barPaddingH + metrics.barBorderWidth) * 2,
            labelStyle: milestoneLabelStyle,
            maxLines: 2,
            onTap: onMilestoneTap == null
                ? null
                : () => onMilestoneTap!.call(placed.milestone),
            child: Container(
              decoration: BoxDecoration(
                color: context.color.secondary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: context.color.secondary,
                  width: metrics.barBorderWidth,
                ),
              ),
              child: Stack(
                children: [
                  // Start dot
                  Positioned(
                    left: -metrics.dotRadius,
                    top: metrics.barHeight / 2 - metrics.dotRadius,
                    child: Container(
                      width: dotSize,
                      height: dotSize,
                      decoration: BoxDecoration(
                        color: context.color.secondary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  // End dot
                  Positioned(
                    right: -metrics.dotRadius,
                    top: metrics.barHeight / 2 - metrics.dotRadius,
                    child: Container(
                      width: dotSize,
                      height: dotSize,
                      decoration: BoxDecoration(
                        color: context.color.secondary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  // Milestone name text
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: metrics.barPaddingH,
                      vertical: metrics.barPaddingV,
                    ),
                    child: Text(
                      milestoneName,
                      style: milestoneLabelStyle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // ===== Subactivity chips (green): one row each =====
        ...placed.subActivities.asMap().entries.map((entry) {
          final int index = entry.key;
          final PlacedSubActivity sub = entry.value;
          final String subName = sub.subActivity.name ?? '';

          final double subWidth = (sub.endOffset - sub.startOffset) * weekWidth;
          final double top =
              metrics.barHeight +
              metrics.chipSpacing +
              index * (metrics.chipHeight + metrics.chipSpacing);

          return Positioned(
            top: top,
            left: _leftOf(sub.startOffset, sub.endOffset),
            width: subWidth,
            height: metrics.chipHeight,
            child: TimelineLabelTooltip(
              message: subName,
              details: formatTimelineDateRange(
                sub.subActivity.startDate,
                sub.subActivity.endDate,
              ),
              availableWidth:
                  subWidth -
                  (metrics.chipPaddingH + metrics.chipBorderWidth) * 2,
              labelStyle: subactivityLabelStyle,
              onTap: onSubactivityTap == null
                  ? null
                  : () => onSubactivityTap!.call(sub.subActivity),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: metrics.chipPaddingH,
                  vertical: metrics.chipPaddingV,
                ),
                decoration: BoxDecoration(
                  color: context.color.tertiaryContainer.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: context.color.tertiaryContainer,
                    width: metrics.chipBorderWidth,
                  ),
                ),
                child: Text(
                  subName,
                  textAlign: TextAlign.start,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: subactivityLabelStyle,
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
