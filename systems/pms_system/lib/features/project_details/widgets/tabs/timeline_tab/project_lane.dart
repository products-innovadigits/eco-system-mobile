import 'package:pms_system/core/utility/pms_exports.dart';

class ProjectLane extends StatelessWidget {
  final String? name;
  final List<ProjectItem> items;

  const ProjectLane({super.key, this.name, required this.items});

  @override
  Widget build(BuildContext context) {
    // Geometry to match intended visual style
    const double lineY = 6;
    const double lineThickness = 2;
    const double dotRadius = 4;
    const double labelTopGap = 8;
    const double pillPaddingV = 8;
    const double pillPaddingH = 10;
    const double pillRadius = 12;

    return LayoutBuilder(
      builder: (ctx, c) {
        final double w = c.maxWidth;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            // Horizontal line
            Positioned(
              top: lineY,
              left: 0,
              right: 0,
              child: Container(height: lineThickness, color: Colors.black),
            ),
            // Start dot
            Positioned(
              top: lineY - dotRadius,
              left: -dotRadius,
              child: Container(
                width: dotRadius * 2,
                height: dotRadius * 2,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            // End dot
            Positioned(
              top: lineY - dotRadius,
              left: w - dotRadius * 2,
              child: Container(
                width: dotRadius * 2,
                height: dotRadius * 2,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
              ),
            ),

            // Label + subproject chips
            Positioned(
              top: lineY + labelTopGap,
              left: 0,
              right: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (name != null && name!.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: pillPaddingV,
                        horizontal: pillPaddingH,
                      ),
                      decoration: BoxDecoration(
                        color: context.color.secondary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(pillRadius),
                      ),
                      child: Text(
                        name!,
                        textAlign: TextAlign.start,
                        style: context.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: context.color.secondary,
                          fontSize: FontSizes.f10,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  if (items.isNotEmpty) SizedBox(height: 8.h),
                  if (items.isNotEmpty)
                    ...List.generate(
                      items.length >= 2 ? 2 : items.length,
                      (i) => Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: pillPaddingV,
                              horizontal: pillPaddingH,
                            ),
                            margin: EdgeInsets.only(
                              right: i == 0 ? 20 : 40,
                              bottom: 8,
                            ),
                            decoration: BoxDecoration(
                              color: context.color.tertiaryContainer.withValues(
                                alpha: 0.2,
                              ),
                              borderRadius: BorderRadius.circular(pillRadius),
                            ),
                            child: Text(
                              items[i].name ?? '',
                              textAlign: TextAlign.start,
                              style: context.textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: context.color.tertiaryContainer,
                                fontSize: FontSizes.f10,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (items.length > 2 && i == 1) ...[
                            SizedBox(width: 6.w),
                            Text(
                              '+${items.length - 2}',
                              style: context.textTheme.labelMedium?.copyWith(
                                color: context.color.outlineVariant,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
