import 'package:flutter/widgets.dart';

class HomeSection {
  final String id;
  final int order;
  final WidgetBuilder builder;

  /// Evaluated on every home build to decide whether this section
  /// participates in the layout at all. Sections that return false are
  /// filtered out before the column is built, so they consume no spacing.
  final bool Function()? isVisible;

  const HomeSection({
    required this.id,
    required this.order,
    required this.builder,
    this.isVisible,
  });

  bool get visible => isVisible?.call() ?? true;
}
