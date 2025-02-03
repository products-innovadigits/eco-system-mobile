import 'package:flutter/material.dart';

class AppNotification {
  final String message;
  final String? iconName;
  final Color backgroundColor;
  final Color borderColor;
  final bool isFloating;
  late final double radius;
  AppNotification(
      {required this.message,
      this.iconName,
      this.backgroundColor = Colors.black,
      this.borderColor = Colors.transparent,
      this.isFloating = false,
      radius}) {
    this.radius = radius ?? this.isFloating ? 15 : 0;
  }
}
