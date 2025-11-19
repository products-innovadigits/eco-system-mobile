import 'dart:math' as math;

import 'package:pms_system/project_details/model/project_timeline_model.dart';
import 'package:pms_system/project_details/widgets/tabs/timeline_tab/timeline_date_utils.dart';
import '../../../../shared/pms_exports.dart';

class MilestoneLane extends StatelessWidget {
  final MilestoneModel milestone;
  final double weekWidth;
  final DateTime projectStart;
  final DateTime projectEnd;
  final bool isExpanded;
  final bool isRTL;
  final VoidCallback onToggleExpansion;
  final void Function(MilestoneModel milestone)? onMilestoneTap;
  final void Function(SubActivityModel subactivity)? onSubactivityTap;

  const MilestoneLane({
    super.key,
    required this.milestone,
    required this.weekWidth,
    required this.projectStart,
    required this.projectEnd,
    required this.isExpanded,
    required this.onToggleExpansion,
    required this.isRTL,
    this.onMilestoneTap,
    this.onSubactivityTap,
  });

  @override
  Widget build(BuildContext context) {
    // Geometry constants
    const double milestoneBarHeight = 32.0;
    const double dotRadius = 4.0;
    const double subactivityChipHeight = 24.0;
    const double subactivitySpacing = 8.0;
    const double connectorLineThickness = 1.0;
    const double moreChipGap = 12.0;

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

        final int totalSubs = subactivities.length;

        // 2) Visible / hidden logic
        final int collapsedVisible = math.min(totalSubs, 2);
        final int visibleSubs = isExpanded ? totalSubs : collapsedVisible;
        final int hiddenCount = totalSubs - visibleSubs;
        final int collapsedHidden = totalSubs - collapsedVisible;

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
              ...subactivities.take(visibleSubs).toList().asMap().entries.map((
                entry,
              ) {
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

                // أفقيًا بالنسبة للميلستون (RTL / LTR)
                double subStartOffset;
                if (isRTL) {
                  final offsetCols = milestoneSpan.endCol - subSpan.endCol;
                  subStartOffset = offsetCols * weekWidth;
                } else {
                  subStartOffset =
                      (subSpan.startCol - milestoneSpan.startCol) * weekWidth;
                }

                final double subWidth = subSpan.width * weekWidth;

                // رأسيًا (سطور تحت بعض)
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

              // ===== Dashed connector lines (قبل الـ toggle) =====
              if (visibleSubs > 0)
                ...subactivities.take(visibleSubs).toList().asMap().entries.map(
                  (entry) {
                    final int index = entry.key;
                    final subactivity = entry.value;

                    final subStartDate = subactivity.startDate;
                    final subEndDate = subactivity.endDate;

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

                    if (milestoneSpan == null) {
                      return const SizedBox.shrink();
                    }

                    double subStartOffset;
                    if (isRTL) {
                      final offsetCols = milestoneSpan.endCol - subSpan.endCol;
                      subStartOffset = offsetCols * weekWidth;
                    } else {
                      subStartOffset =
                          (subSpan.startCol - milestoneSpan.startCol) *
                          weekWidth;
                    }

                    final double subCenterX =
                        subStartOffset + (subSpan.width * weekWidth / 2);

                    final double height =
                        subactivitySpacing +
                        (index * (subactivityChipHeight + subactivitySpacing)) +
                        subactivityChipHeight / 2;

                    return Positioned(
                      top: milestoneBarHeight,
                      left: subCenterX - connectorLineThickness / 2,
                      width: connectorLineThickness,
                      height: height,
                      child: CustomPaint(
                        painter: DashedLinePainter(
                          color: context.color.outlineVariant.withValues(
                            alpha: 0.3,
                          ),
                          strokeWidth: connectorLineThickness,
                        ),
                      ),
                    );
                  },
                ),

              // ===== Toggle chip (+N / -N) جنب آخر subactivity =====
              if (totalSubs > 2)
                Builder(
                  builder: (context) {
                    const double moreChipWidth = 40.0;

                    final milestoneSpan = DateSpan.fromDates(
                      milestone.startDate,
                      milestone.endDate,
                      projectStart,
                      projectEnd,
                    );

                    if (milestoneSpan == null) {
                      return const SizedBox.shrink();
                    }

                    // آخر subactivity ظاهرة حاليًا
                    final int lastVisibleIndex = visibleSubs - 1;
                    final lastSub = subactivities[lastVisibleIndex];

                    final lastStartDate = lastSub.startDate;
                    final lastEndDate = lastSub.endDate;

                    if (lastStartDate == null || lastEndDate == null) {
                      return const SizedBox.shrink();
                    }

                    final lastSpan = DateSpan.fromDates(
                      lastStartDate,
                      lastEndDate,
                      projectStart,
                      projectEnd,
                    );

                    if (lastSpan == null) {
                      return const SizedBox.shrink();
                    }

                    double lastStartOffset;
                    if (isRTL) {
                      final offsetCols = milestoneSpan.endCol - lastSpan.endCol;
                      lastStartOffset = offsetCols * weekWidth;
                    } else {
                      lastStartOffset =
                          (lastSpan.startCol - milestoneSpan.startCol) *
                          weekWidth;
                    }

                    final double lastWidth = lastSpan.width * weekWidth;

                    // مستطيل آخر subactivity
                    final double chipLeft = lastStartOffset;
                    final double chipRight = lastStartOffset + lastWidth;

                    // نخلي الـ chip جنب آخر subactivity من برّه، مش فوقها
                    double moreLeft;
                    if (isRTL) {
                      // RTL: الكونتينر على الشمال من الشيب
                      moreLeft = chipLeft - moreChipWidth - moreChipGap;
                    } else {
                      // LTR: الكونتينر على اليمين من الشيب
                      moreLeft = chipRight + moreChipGap;
                    }

                    // نفس السطر بتاع آخر subactivity
                    final double chipTop =
                        milestoneBarHeight +
                        subactivitySpacing +
                        (lastVisibleIndex *
                            (subactivityChipHeight + subactivitySpacing));

                    final double moreTop = chipTop;

                    // نص الكونتينر
                    final String pillText = hiddenCount > 0
                        ? '+$hiddenCount'
                        : '-$collapsedHidden';

                    return Positioned(
                      top: moreTop,
                      left: moreLeft,
                      width: moreChipWidth,
                      height: subactivityChipHeight,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: onToggleExpansion,
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: context.color.outlineVariant.withValues(
                              alpha: 0.15,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: context.color.outlineVariant,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            pillText,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: FontSizes.f10,
                              color: context.color.outlineVariant,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
            ],
          ],
        );
      },
    );
  }
}

class DashedLinePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  DashedLinePainter({required this.color, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    const dashWidth = 3.0;
    const dashSpace = 2.0;
    double startY = 0;

    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashWidth), paint);
      startY += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
