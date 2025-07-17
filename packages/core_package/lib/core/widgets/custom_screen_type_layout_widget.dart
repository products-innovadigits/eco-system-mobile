import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class CustomScreenTypeLayoutWidget extends StatelessWidget {
  const CustomScreenTypeLayoutWidget({
    super.key,
    required this.mobilePortrait,
    required this.mobileLandscape,
    this.tabletPortrait,
    this.tabletLandscape,
  });
  final Widget Function(BuildContext context) mobilePortrait;
  final Widget Function(BuildContext context) mobileLandscape;
  final Widget Function(BuildContext context)? tabletPortrait;
  final Widget Function(BuildContext context)? tabletLandscape;

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      // breakpoints: AppConstant.breakpoints,
      mobile: (_) => OrientationLayoutBuilder(
        portrait: mobilePortrait,
        landscape: mobileLandscape,
      ),
      tablet: (_) => OrientationLayoutBuilder(
        portrait: tabletPortrait ?? mobilePortrait,
        landscape: tabletLandscape ?? mobileLandscape,
      ),
      desktop: (_) => OrientationLayoutBuilder(
        portrait: tabletPortrait ?? mobilePortrait,
        landscape: tabletLandscape ?? mobileLandscape,
      ),
    );
  }
}
