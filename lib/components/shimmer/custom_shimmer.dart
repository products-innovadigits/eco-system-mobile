import 'package:flutter/material.dart';
import 'package:eco_system/helpers/media_query_helper.dart';
import 'package:shimmer/shimmer.dart';

class CustomShimmer extends StatelessWidget {
  final Widget? child;
  final Color? color;
  final Color? subColor;
  const CustomShimmer({Key? key, this.child, this.color, this.subColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: color ??  Colors.grey[100]!,
      highlightColor: subColor ?? Colors.grey[300]!,
      child: child!,
    );
  }
}

class CustomShimmerText extends StatelessWidget {
  final double? width;
  const CustomShimmerText({Key? key, this.width, }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  CustomShimmer(
      child: Container(
        height: 10,
        width: width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white),
      ),
    );
  }
}


class CustomShimmerCircleImage extends StatelessWidget {
  final double? radius;
  const CustomShimmerCircleImage({Key? key, this.radius}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomShimmer(
      child: Container(
        height: radius,
        width: radius,
        decoration: const BoxDecoration(
            shape: BoxShape.circle, color: Colors.white),
      ),
    );
  }
}

class CustomShimmerContainer extends StatelessWidget {
  final double? height;
  final double? width;
  const CustomShimmerContainer({Key? key, this.height, this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomShimmer(
      child: Container(
        height: height,
        width: width ?? MediaQueryHelper.width,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0)),
      ),
    );
  }
}

