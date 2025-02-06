import 'package:flutter/material.dart';

class ErrorMessage extends StatelessWidget {
  final String? text;
  final dynamic margin;
  final dynamic height;

  const ErrorMessage({
    super.key,
    this.text,
    this.margin,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text ?? "Shared Error !",
        textAlign: TextAlign.center,
      ),
    );
  }
}
