import 'package:project_management/core/utility/project_management_exports.dart';
import 'package:project_management/features/ai_assistant/util/ai_assistant_query_field_labels.dart';

/// Result row for [AiAssistantBody] only: shows all API fields dynamically and opens project details by id.
class AiAssistantProjectResultCard extends StatelessWidget {
  const AiAssistantProjectResultCard({super.key, required this.item});

  final AiAssistantQueryItem item;

  @override
  Widget build(BuildContext context) {
    final id = item.projectId;
    final visibleKeys = item.displayKeyOrder
        .where((k) => !isAiAssistantQueryIdFieldKey(k))
        .toList(growable: false);
    final radius = BorderRadius.circular(12.r);
    final innerShadowColor = Color.lerp(
      context.color.primary,
      Colors.black,
      0.2,
    )!.withValues(alpha: 0.25);
    final innerShadowWidth = 10.w;
    final innerShadowHeight = 10.h;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        color: context.color.surface,
        borderRadius: radius,

        boxShadow: [
          BoxShadow(
            color: LightColor.white.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          PositionedDirectional(
            start: 0,
            top: 0,
            bottom: 0,
            width: innerShadowWidth,
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: AlignmentDirectional.centerStart,
                    end: AlignmentDirectional.centerEnd,
                    colors: [
                      innerShadowColor,
                      innerShadowColor.withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: innerShadowHeight,
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      innerShadowColor,
                      innerShadowColor.withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Material(
            color: Colors.transparent,
            borderRadius: radius,
            child: InkWell(
              onTap: id == null
                  ? null
                  : () => CustomNavigator.push(
                      Routes.PROJECT_DETAILS,
                      arguments: id,
                    ),
              borderRadius: radius,
              splashColor: context.color.primary.withValues(alpha: 0.08),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var i = 0; i < visibleKeys.length; i++) ...[
                      if (i > 0) SizedBox(height: 10.h),
                      Text(
                        localizedAiAssistantQueryFieldLabel(visibleKeys[i]),
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: context.color.secondary,
                          fontWeight: FontWeight.w500,
                          height: 1.25,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        item.fields[visibleKeys[i]] ?? '',
                        style: context.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          height: 1.35,
                        ),
                      ),
                      if (i < visibleKeys.length - 1)
                        Divider(
                          color: context.color.outlineVariant.withValues(
                            alpha: .2,
                          ),
                        ),
                    ],
                    SizedBox(height: 12.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          allTranslations.text(LocaleKeys.project_details),
                          style: context.textTheme.labelSmall?.copyWith(
                            color: context.color.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Icon(
                          Directionality.of(context) == TextDirection.ltr
                              ? Icons.chevron_left_rounded
                              : Icons.chevron_right_rounded,
                          size: 20.sp,
                          color: context.color.primary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
