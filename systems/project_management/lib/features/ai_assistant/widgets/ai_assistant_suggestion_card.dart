import 'package:project_management/core/utility/project_management_exports.dart';

/// A single clickable clarification suggestion, rendered as a compact card in a
/// 2-column grid. Tapping re-sends [suggestion.question] to the query API.
class AiAssistantSuggestionCard extends StatelessWidget {
  const AiAssistantSuggestionCard({
    super.key,
    required this.suggestion,
    required this.onTap,
    this.enabled = true,
  });

  final AiAssistantSuggestion suggestion;
  final ValueChanged<AiAssistantSuggestion> onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(12.r);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.color.surface,
        borderRadius: radius,
        border: Border.all(
          color: context.color.primary.withValues(alpha: 0.30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: radius,
        child: InkWell(
          onTap: enabled ? () => onTap(suggestion) : null,
          borderRadius: radius,
          splashColor: context.color.primary.withValues(alpha: 0.10),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.auto_awesome_rounded,
                  size: 18.sp,
                  color: context.color.primary.withValues(
                    alpha: enabled ? 1 : 0.5,
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    suggestion.label,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.color.onSurface.withValues(
                        alpha: enabled ? 1 : 0.5,
                      ),
                      fontWeight: FontWeight.w600,
                      height: 1.25,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
