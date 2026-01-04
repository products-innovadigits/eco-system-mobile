import 'package:flutter/widgets.dart';

class HomeSection {
  final String id;
  final int order;
  final WidgetBuilder builder;

  const HomeSection({
    required this.id,
    required this.order,
    required this.builder,
  });
}
