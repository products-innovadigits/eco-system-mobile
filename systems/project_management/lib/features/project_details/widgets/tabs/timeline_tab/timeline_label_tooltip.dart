import 'package:project_management/core/utility/project_management_exports.dart';

/// How long a timeline tooltip stays on screen before it dismisses itself.
const Duration kTimelineTooltipDuration = Duration(seconds: 3);

/// Shows the full name and the exact dates of a timeline item (milestone bar /
/// sub-activity chip) when the user taps it.
///
/// Two things make this the item's only readable form:
/// * short items only get one or two week columns, so their label is
///   ellipsized;
/// * the grid snaps to week cells, so a bar's width says which weeks an item
///   touches, not how long it really runs.
///
/// The tooltip therefore carries the name plus [details] (the date range), and:
///   * dismisses itself after [kTimelineTooltipDuration],
///   * dismisses immediately when the user taps outside it,
///   * is replaced by the new one when another item is tapped — Material keeps
///     a single tooltip visible at a time.
///
/// With no [details] to add, it is attached only when the label really
/// overflows, so a bar wide enough to show its full name stays plain content.
class TimelineLabelTooltip extends StatelessWidget {
  /// The item's label, as rendered inside the bar / chip.
  final String message;

  /// Secondary line — the item's date range. Always worth showing when set.
  final String? details;

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
    this.details,
    this.labelStyle,
    this.maxLines = 1,
    this.onTap,
  });

  bool get _hasDetails => details != null && details!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    if (!_hasDetails && !_isLabelTruncated(context)) {
      if (onTap == null) return child;
      return GestureDetector(onTap: onTap, child: child);
    }

    final TextStyle? baseStyle = context.textTheme.labelSmall?.copyWith(
      color: context.color.onPrimary,
      fontWeight: FontWeight.w600,
      fontSize: FontSizes.f12,
    );

    return Tooltip(
      richMessage: TextSpan(
        text: message.trim(),
        children: [
          if (_hasDetails)
            TextSpan(
              text: '\n${details!}',
              style: baseStyle?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: FontSizes.f12,
                color: context.color.onPrimary.withValues(alpha: 0.75),
              ),
            ),
        ],
      ),
      triggerMode: TooltipTriggerMode.tap,
      waitDuration: Duration.zero,
      showDuration: kTimelineTooltipDuration,
      preferBelow: false,
      enableFeedback: true,
      onTriggered: onTap,
      // Logical pixels, not `.w`/`.h`: ScreenUtil is set up against a portrait
      // design size, so those scale by ~2.2x once the screen is landscape.
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: context.color.onSurface.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: baseStyle,
      textAlign: TextAlign.start,
      child: child,
    );
  }

  /// Lays the label out off-screen with the exact style/constraints the visible
  /// [Text] uses, to know whether the user is seeing an ellipsis.
  bool _isLabelTruncated(BuildContext context) {
    final String text = message.trim();
    if (text.isEmpty || !availableWidth.isFinite) return false;
    // No room at all: the label is certainly unreadable.
    if (availableWidth <= 0) return true;

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
