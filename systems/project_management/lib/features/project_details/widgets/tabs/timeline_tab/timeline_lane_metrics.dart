import 'package:project_management/core/utility/project_management_exports.dart';

/// Geometry of a milestone lane, in logical pixels.
///
/// Single source of truth for two places that must agree: [MilestoneLane]
/// paints with these values, and the timeline reserves each band's height from
/// [contentHeightFor]. When they drifted apart, lanes overlapped the row below.
///
/// [scale] enlarges the whole lane together — bar, chips, spacing and label —
/// so a bigger canvas (full screen) reads better instead of just gaining
/// whitespace around the same small bars.
class TimelineLaneMetrics {
  final double scale;

  const TimelineLaneMetrics({this.scale = 1});

  double get barHeight => 42 * scale;

  double get dotRadius => 4 * scale;

  double get chipHeight => 28 * scale;

  double get chipSpacing => 4 * scale;

  /// Breathing room kept above and below a lane inside its band.
  double get lanePadding => 6 * scale;

  // Inner insets of the bar / chip. Needed to render them and to know how much
  // width their label really has (see [TimelineLabelTooltip]).
  double get barPaddingH => 12 * scale;

  double get barPaddingV => 6 * scale;

  double get barBorderWidth => 1.5;

  double get chipPaddingH => 8 * scale;

  double get chipPaddingV => 4 * scale;

  double get chipBorderWidth => 1;

  double get labelFontSize => FontSizes.f10 * scale;

  /// Height a lane needs for a milestone carrying [subActivityCount] chips.
  double contentHeightFor(int subActivityCount) {
    if (subActivityCount <= 0) return barHeight;
    return barHeight +
        chipSpacing +
        subActivityCount * (chipHeight + chipSpacing);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TimelineLaneMetrics && other.scale == scale);

  @override
  int get hashCode => scale.hashCode;
}
