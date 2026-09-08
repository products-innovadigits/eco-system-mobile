import 'package:project_management/core/utility/project_management_exports.dart';

/// Renders one milestone bar and its sub-activity chips inside the lane the
/// layout pass reserved for them.
///
/// All date math is done once during layout ([PlacedMilestone]); this widget
/// only turns column offsets into pixels.
class MilestoneLane extends StatelessWidget {
  final PlacedMilestone placed;
  final double weekWidth;
  final bool isRTL;
  final void Function(MilestoneModel milestone)? onMilestoneTap;
  final void Function(SubActivityModel subactivity)? onSubactivityTap;

  const MilestoneLane({
    super.key,
    required this.placed,
    required this.weekWidth,
    required this.isRTL,
    this.onMilestoneTap,
    this.onSubactivityTap,
  });

  // Geometry of a lane. The layout pass reserves the band height from
  // [contentHeightFor], so these are the single source of truth for both.
  static const double milestoneBarHeight = 42.0;
  static const double dotRadius = 4.0;
  static const double subactivityChipHeight = 28.0;
  static const double subactivitySpacing = 4.0;

  /// Vertical breathing room kept above and below a lane inside its band.
  static const double lanePadding = 6.0;

  // Inner insets of the bar / chip, used both to render them and to know how
  // much width their label really has (see [TimelineLabelTooltip]).
  static const double _barPaddingH = 12.0;
  static const double _barBorderWidth = 1.5;
  static const double _chipPaddingH = 8.0;
  static const double _chipBorderWidth = 1.0;

  /// Height the lane needs for a milestone carrying [subActivityCount] chips.
  static double contentHeightFor(int subActivityCount) {
    if (subActivityCount <= 0) return milestoneBarHeight;
    return milestoneBarHeight +
        subactivitySpacing +
        subActivityCount * (subactivityChipHeight + subactivitySpacing);
  }

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
          fontSize: FontSizes.f10,
        );
    final TextStyle? subactivityLabelStyle = context.textTheme.labelSmall
        ?.copyWith(
          fontWeight: FontWeight.w700,
          color: context.color.tertiaryContainer,
          fontSize: FontSizes.f10,
        );

    final String milestoneName = placed.milestone.name ?? '';
    final double barWidth =
        (placed.barEndOffset - placed.barStartOffset) * weekWidth;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // ===== Milestone bar (blue) =====
        Positioned(
          top: 0,
          left: _leftOf(placed.barStartOffset, placed.barEndOffset),
          width: barWidth,
          height: milestoneBarHeight,
          child: TimelineLabelTooltip(
            message: milestoneName,
            details: formatTimelineDateRange(
              placed.milestone.startDate,
              placed.milestone.endDate,
            ),
            availableWidth: barWidth - (_barPaddingH + _barBorderWidth) * 2,
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
                  width: _barBorderWidth,
                ),
              ),
              child: Stack(
                children: [
                  // Start dot
                  Positioned(
                    left: -dotRadius,
                    top: milestoneBarHeight / 2 - dotRadius,
                    child: Container(
                      width: dotRadius * 2,
                      height: dotRadius * 2,
                      decoration: BoxDecoration(
                        color: context.color.secondary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  // End dot
                  Positioned(
                    right: -dotRadius,
                    top: milestoneBarHeight / 2 - dotRadius,
                    child: Container(
                      width: dotRadius * 2,
                      height: dotRadius * 2,
                      decoration: BoxDecoration(
                        color: context.color.secondary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  // Milestone name text
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: _barPaddingH,
                      vertical: 6,
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
              milestoneBarHeight +
              subactivitySpacing +
              index * (subactivityChipHeight + subactivitySpacing);

          return Positioned(
            top: top,
            left: _leftOf(sub.startOffset, sub.endOffset),
            width: subWidth,
            height: subactivityChipHeight,
            child: TimelineLabelTooltip(
              message: subName,
              details: formatTimelineDateRange(
                sub.subActivity.startDate,
                sub.subActivity.endDate,
              ),
              availableWidth: subWidth - (_chipPaddingH + _chipBorderWidth) * 2,
              labelStyle: subactivityLabelStyle,
              onTap: onSubactivityTap == null
                  ? null
                  : () => onSubactivityTap!.call(sub.subActivity),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: _chipPaddingH,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: context.color.tertiaryContainer.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: context.color.tertiaryContainer,
                    width: _chipBorderWidth,
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
