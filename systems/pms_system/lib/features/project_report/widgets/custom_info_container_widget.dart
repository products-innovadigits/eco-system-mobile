import 'package:pms_system/core/utility/pms_exports.dart';

class CustomInfoContainerWidget extends StatelessWidget {
  final Color color;
  final String title;
  final double? radius;
  final double? fontSize;
  final EdgeInsets? padding;

  const CustomInfoContainerWidget({
    super.key,
    required this.color,
    required this.title,
    this.radius,
    this.padding,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(radius ?? 8),
      ),
      child: Text(
        title,
        style: context.textTheme.labelSmall?.copyWith(
          color: color,
          fontSize: fontSize,
        ),
      ),
    );
  }
}
