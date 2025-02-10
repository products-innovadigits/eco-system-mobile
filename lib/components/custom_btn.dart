import 'package:flutter/material.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomBtn extends StatelessWidget {
  const CustomBtn({
    super.key,
    required this.text,
    this.color,
    this.textColor,
    this.onPressed,
    this.width,
    this.height = 56,
    this.loading = false,
    this.active = true,
    this.borderColor = Colors.transparent,
    this.fontSize = 16,
  });
  final String text;
  final Color? color;
  final Color borderColor;
  final Color? textColor;
  final Function()? onPressed;
  final double? width;
  final double height;
  final bool loading;
  final bool active;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (loading) return;
        if (active) onPressed?.call();
      },
      child: Opacity(
        opacity: active ? 1 : 0.6,
        child: Container(
          height: height.h,
          width: width,
          decoration: BoxDecoration(
            color: color ?? context.color.primary,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: borderColor,
            ),
          ),
          child: Center(
            child: loading
                ? SpinKitThreeBounce(
                    color: context.theme.cardColor,
                    size: 25,
                  )
                : Text(
                    text,
                    style: context.textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: textColor ?? context.color.background,
                      fontSize: fontSize,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
