import 'package:project_management/core/utility/project_management_exports.dart';

class MilestoneLane extends StatelessWidget {
  final MilestoneModel milestone;
  final double weekWidth;
  final DateTime projectStart;
  final DateTime projectEnd;
  final bool isRTL;
  final void Function(MilestoneModel milestone)? onMilestoneTap;
  final void Function(SubActivityModel subactivity)? onSubactivityTap;

  const MilestoneLane({
    super.key,
    required this.milestone,
    required this.weekWidth,
    required this.projectStart,
    required this.projectEnd,
    required this.isRTL,
    this.onMilestoneTap,
    this.onSubactivityTap,
  });

  // Geometry constants for vertical layout inside a single lane.
  // NOTE: The parent timeline layout allocates lane height based on the
  // number of subactivities using `rowBandForSubs` so that these values
  // (bar height + chip height + spacing) fit without overlapping the lane
  // below.
  static const double milestoneBarHeight = 42.0;
  static const double dotRadius = 4.0;
  static const double subactivityChipHeight = 28.0;
  static const double subactivitySpacing = 4.0;

  // Inner insets of the bar / chip, used both to render them and to know how
  // much width their label really has (see [TimelineLabelTooltip]).
  static const double _barPaddingH = 12.0;
  static const double _barBorderWidth = 1.5;
  static const double _chipPaddingH = 8.0;
  static const double _chipBorderWidth = 1.0;

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

    return LayoutBuilder(
      builder: (ctx, constraints) {
        // 1) Sort subactivities by start date
        final List<SubActivityModel> subactivities =
            (milestone.subActivities ?? []).toList()..sort((a, b) {
              if (a.startDate == null && b.startDate == null) return 0;
              if (a.startDate == null) return 1;
              if (b.startDate == null) return -1;
              return a.startDate!.compareTo(b.startDate!);
            });

        final String milestoneName = milestone.name ?? '';
        final double milestoneLabelWidth =
            constraints.maxWidth - (_barPaddingH + _barBorderWidth) * 2;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            // ===== Milestone bar (blue) =====
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: milestoneBarHeight,
              child: TimelineLabelTooltip(
                message: milestoneName,
                availableWidth: milestoneLabelWidth,
                labelStyle: milestoneLabelStyle,
                maxLines: 2,
                onTap: onMilestoneTap == null
                    ? null
                    : () => onMilestoneTap!.call(milestone),
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

            if (subactivities.isNotEmpty) ...[
              // ===== Subactivity chips (green) =====
              ...subactivities.asMap().entries.map((entry) {
                final int index = entry.key;
                final subactivity = entry.value;

                final subStartDate = subactivity.startDate;
                final subEndDate = subactivity.endDate;
                final subName = subactivity.name ?? '';

                if (subStartDate == null || subEndDate == null) {
                  return const SizedBox.shrink();
                }

                final subSpan = DateSpan.fromDates(
                  subStartDate,
                  subEndDate,
                  projectStart,
                  projectEnd,
                );

                if (subSpan == null) return const SizedBox.shrink();

                final milestoneSpan = DateSpan.fromDates(
                  milestone.startDate,
                  milestone.endDate,
                  projectStart,
                  projectEnd,
                );

                if (milestoneSpan == null) return const SizedBox.shrink();

                // Horizontal placement relative to milestone span (RTL / LTR)
                double subStartOffset;
                if (isRTL) {
                  final offsetCols = milestoneSpan.endCol - subSpan.endCol;
                  subStartOffset = offsetCols * weekWidth;
                } else {
                  subStartOffset =
                      (subSpan.startCol - milestoneSpan.startCol) * weekWidth;
                }

                final double subWidth = subSpan.width * weekWidth;
                final double subLabelWidth =
                    subWidth - (_chipPaddingH + _chipBorderWidth) * 2;

                // Vertical placement: one row per subactivity
                final double top =
                    milestoneBarHeight +
                    subactivitySpacing +
                    (index * (subactivityChipHeight + subactivitySpacing));

                return Positioned(
                  top: top,
                  left: subStartOffset,
                  width: subWidth,
                  height: subactivityChipHeight,
                  child: TimelineLabelTooltip(
                    message: subName,
                    availableWidth: subLabelWidth,
                    labelStyle: subactivityLabelStyle,
                    onTap: onSubactivityTap == null
                        ? null
                        : () => onSubactivityTap!.call(subactivity),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: _chipPaddingH,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: context.color.tertiaryContainer.withValues(
                          alpha: 0.2,
                        ),
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
          ],
        );
      },
    );
  }
}
