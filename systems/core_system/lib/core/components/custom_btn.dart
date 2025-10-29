import 'package:core_system/core/helpers/font_sizes.dart';
import 'package:core_system/core/utility/export.dart';

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
    this.loadingColor,
    this.active = true,
    this.borderColor = Colors.transparent,
    this.fontSize = FontSizes.f16, this.borderRadius,
  });
  final String text;
  final Color? color;
  final Color borderColor;
  final Color? textColor;
  final Function()? onPressed;
  final double? width;
  final double height;
  final bool loading;
  final Color? loadingColor;
  final bool active;
  final double fontSize;
  final double? borderRadius;

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
            borderRadius: BorderRadius.circular(borderRadius ?? 12),
            border: Border.all(
              color: borderColor,
            ),
          ),
          child: Center(
            child: loading
                ? SpinKitThreeBounce(
                    color: loadingColor ?? context.theme.cardColor,
                    size: 25,
                  )
                : Text(
                    text,
                    style: context.textTheme.titleSmall?.copyWith(
                      color: textColor ?? context.color.onPrimary,
                      fontSize: fontSize,
                      fontWeight: FontWeight.w600
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
