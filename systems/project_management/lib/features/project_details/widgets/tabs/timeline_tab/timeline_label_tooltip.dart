import 'package:project_management/core/utility/project_management_exports.dart';

/// How long a timeline tooltip stays on screen before it dismisses itself.
const Duration kTimelineTooltipDuration = Duration(seconds: 3);

/// Reveals the full label of a timeline item (milestone bar / sub-activity chip)
/// when the user taps it.
///
/// Items with a short duration only get one or two week columns, so their label
/// is ellipsized and the user has no way to read it. Tapping such an item opens
/// a tooltip with the full text, which:
///   * dismisses itself after [kTimelineTooltipDuration],
///   * dismisses immediately when the user taps outside it,
///   * is replaced by the new one when another item is tapped — Material keeps
///     a single tooltip visible at a time.
///
/// The tooltip is attached only when the label really overflows, so bars that
/// are wide enough to show their full name keep their plain behaviour.
class TimelineLabelTooltip extends StatelessWidget {
  /// Full text of the item, shown inside the tooltip.
  final String message;

  /// Width the label itself can use (item width minus its paddings/borders).
  final double availableWidth;

  /// Style and line budget the label is rendered with — used to detect
  /// truncation, so they must match the underlying [Text].
  final TextStyle? labelStyle;
  final int maxLines;

  /// Forwarded on tap, whether or not a tooltip is shown.
  final VoidCallback? onTap;

  final Widget child;

  const TimelineLabelTooltip({
    super.key,
    required this.message,
    required this.availableWidth,
    required this.child,
    this.labelStyle,
    this.maxLines = 1,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (!_isLabelTruncated(context)) {
      if (onTap == null) return child;
      return GestureDetector(onTap: onTap, child: child);
    }

    return Tooltip(
      message: message.trim(),
      triggerMode: TooltipTriggerMode.tap,
      waitDuration: Duration.zero,
      showDuration: kTimelineTooltipDuration,
      preferBelow: false,
      enableFeedback: true,
      onTriggered: onTap,
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: context.color.onSurface.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: context.textTheme.labelSmall?.copyWith(
        color: context.color.onPrimary,
        fontWeight: FontWeight.w600,
        fontSize: FontSizes.f12,
      ),
      textAlign: TextAlign.start,
      child: child,
    );
  }

  /// Lays the label out off-screen with the exact style/constraints the visible
  /// [Text] uses, to know whether the user is seeing an ellipsis.
  bool _isLabelTruncated(BuildContext context) {
    final String text = message.trim();
    if (text.isEmpty || availableWidth <= 0 || !availableWidth.isFinite) {
      return false;
    }

    final TextPainter painter = TextPainter(
      text: TextSpan(text: text, style: labelStyle),
      maxLines: maxLines,
      textDirection: Directionality.of(context),
      textScaler: MediaQuery.textScalerOf(context),
    )..layout(maxWidth: availableWidth);

    // `didExceedMaxLines` covers wrapped text; the width check covers a single
    // unbreakable word that is wider than the item.
    const double epsilon = 0.5;
    final bool truncated =
        painter.didExceedMaxLines || painter.width > availableWidth + epsilon;

    painter.dispose();
    return truncated;
  }
}
