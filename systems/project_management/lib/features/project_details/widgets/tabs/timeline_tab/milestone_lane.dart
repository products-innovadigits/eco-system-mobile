import 'package:project_management/core/utility/pms_exports.dart';

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

  @override
  Widget build(BuildContext context) {
    // Geometry constants for vertical layout inside a single lane.
    // NOTE: The parent timeline layout allocates lane height based on the
    // number of subactivities using `rowBandForSubs` so that these values
    // (bar height + chip height + spacing) fit without overlapping the lane
    // below.
    const double milestoneBarHeight = 42.0;
    const double dotRadius = 4.0;
    const double subactivityChipHeight = 28.0;
    const double subactivitySpacing = 4.0;

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

        return Stack(
          clipBehavior: Clip.none,
          children: [
            // ===== Milestone bar (blue) =====
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: milestoneBarHeight,
              child: GestureDetector(
                onTap: () => onMilestoneTap?.call(milestone),
                child: Container(
                  decoration: BoxDecoration(
                    color: context.color.secondary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: context.color.secondary,
                      width: 1.5,
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
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: Text(
                          milestone.name ?? '',
                          style: context.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: context.color.secondary,
                            fontSize: FontSizes.f10,
                          ),
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
                  child: GestureDetector(
                    onTap: () => onSubactivityTap?.call(subactivity),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: context.color.tertiaryContainer.withValues(
                          alpha: 0.2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: context.color.tertiaryContainer,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        subName,
                        textAlign: TextAlign.start,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: context.color.tertiaryContainer,
                          fontSize: FontSizes.f10,
                        ),
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
