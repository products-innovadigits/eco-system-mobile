import 'package:flutter/material.dart';
import 'package:eco_system/helpers/media_query_helper.dart';
import 'package:eco_system/helpers/styles.dart';

class ImageBG extends StatelessWidget {
  final String? image;
  final bool isOpacity;
  const ImageBG({
    super.key,
    this.image,
    this.isOpacity = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Image.asset(
            'assets/images/${image ?? "boarding-bg.png"}',
            fit: BoxFit.cover,
            height: MediaQueryHelper.height,
            width: MediaQueryHelper.width,
          ),
        ),
        Visibility(
          visible: isOpacity,
          child: Container(
            color: Styles.BOARDING_BLUR,
            height: MediaQueryHelper.height,
            width: MediaQueryHelper.width,
          ),
        )
      ],
    );
  }
}
