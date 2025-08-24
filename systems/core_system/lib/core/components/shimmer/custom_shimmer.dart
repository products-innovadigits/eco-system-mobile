import 'package:core_system/core/utility/export.dart';

class CustomShimmer extends StatelessWidget {
  final Widget? child;
  final Color? color;
  final Color? subColor;

  const CustomShimmer({super.key, this.child, this.color, this.subColor});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: color ?? Colors.grey[100]!,
      highlightColor: subColor ?? Colors.grey[300]!,
      child: child!,
    );
  }
}

class CustomShimmerText extends StatelessWidget {
  final double? width;

  const CustomShimmerText({super.key, this.width});

  @override
  Widget build(BuildContext context) {
    return CustomShimmer(
      child: Container(
        height: 10,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
        ),
      ),
    );
  }
}

class CustomShimmerCircleImage extends StatelessWidget {
  final double? radius;

  const CustomShimmerCircleImage({super.key, this.radius});

  @override
  Widget build(BuildContext context) {
    return CustomShimmer(
      child: Container(
        height: radius,
        width: radius,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
      ),
    );
  }
}

class CustomShimmerContainer extends StatelessWidget {
  final double? height;
  final double? width;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;

  const CustomShimmerContainer({
    super.key,
    this.height,
    this.width,
    this.borderRadius,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return CustomShimmer(
      child: Container(
        height: height ?? context.h * 0.2,
        width: width ?? context.w,
        padding: padding ?? EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius ?? 15.0),
        ),
      ),
    );
  }
}
