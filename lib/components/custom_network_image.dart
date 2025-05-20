import 'package:cached_network_image/cached_network_image.dart';
import 'package:eco_system/utility/export.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomNetworkImage {
  static const key = 'customCacheKey';
  static dynamic cacheManger;
  static CustomNetworkImage? _instance;

  CustomNetworkImage._internal();

  factory CustomNetworkImage() {
    _instance ??= CustomNetworkImage._internal();
    return _instance!;
  }

  static Widget containerNewWorkImage({
    String image = "",
    double? radius,
    String? defaultImage,
    double? height,
    double? width,
    String? customImage,
    BoxFit fit = BoxFit.contain,
    isPlaceHolder = true,
    double? widthOfShimmer,
    bool edges = false,
  }) {
    return CachedNetworkImage(
      imageUrl: image == "" ? "https://" : image,
      fadeInDuration: const Duration(seconds: 1),
      fadeOutDuration: const Duration(seconds: 1),
      errorWidget: (a, b, c) => Container(
        width: width ?? 40,
        height: height ?? 40,
        decoration: BoxDecoration(
          borderRadius: edges
              ? BorderRadius.only(
                  topRight: Radius.circular(radius ?? 10),
                  topLeft: Radius.circular(radius ?? 10),
                )
              : BorderRadius.all(Radius.circular(radius ?? 10.0)),
          image: DecorationImage(
            fit: fit,
            image: Image.asset(
              defaultImage ?? "assets/app_icon.png",
              fit: BoxFit.contain,
            ).image,
          ),
        ),
      ),
      placeholder: (context, url) {
        return isPlaceHolder
            ? Container(
                width: width ?? 40,
                height: height ?? 40,
                decoration: BoxDecoration(
                  borderRadius: edges
                      ? BorderRadius.only(
                          topRight: Radius.circular(radius ?? 10),
                          topLeft: Radius.circular(radius ?? 10))
                      : BorderRadius.all(Radius.circular(radius ?? 10.0)),
                  image: DecorationImage(
                    fit: fit,
                    image: Image.asset(
                      defaultImage ?? "assets/splash.png",
                      fit: BoxFit.contain,
                    ).image,
                  ),
                ),
              )
            : Container();
      },
      imageBuilder: (context, provider) {
        return Container(
          width: width ?? 40,
          height: height ?? 40,
          decoration: BoxDecoration(
            borderRadius: edges
                ? BorderRadius.only(
                    topRight: Radius.circular(radius ?? 10),
                    topLeft: Radius.circular(radius ?? 10))
                : BorderRadius.all(
                    Radius.circular(radius ?? 10.0),
                  ),
            image: DecorationImage(
              fit: fit,
              image: provider,
            ),
          ),
        );
      },
    );
  }

  /// Circle Network Image
  static Widget circleNewWorkImage(
      {String? image,
      double? radius,
      String? defaultImage,
      bool isDefaultSvg = true,
      backGroundColor,
      color}) {
    return CachedNetworkImage(
      imageUrl: image == "" || image == null ? "https://" : image,
      repeat: ImageRepeat.noRepeat,
      errorWidget: (a, c, b) => Container(
        padding: EdgeInsets.all(8),
        height: radius != null ? radius * 2 : null,
        width: radius != null ? radius * 2 : null,
        decoration: BoxDecoration(
            border: color != null ? Border.all(color: color, width: 1) : null,
            shape: BoxShape.circle),
        child: CircleAvatar(
          radius: radius,
          backgroundColor: backGroundColor ?? Colors.white,
          child: SvgPicture.asset(
            Assets.svgs.user.path,
            colorFilter: ColorFilter.mode(Styles.WHITE_COLOR, BlendMode.srcIn),
          ),
        ),
      ),
      fadeInDuration: const Duration(seconds: 1),
      fadeOutDuration: const Duration(seconds: 2),
      placeholder: (context, url) => Container(
        height: radius != null ? radius * 2 : null,
        width: radius != null ? radius * 2 : null,
        decoration: BoxDecoration(
            border: color != null ? Border.all(color: color, width: 1) : null,
            shape: BoxShape.circle),
        child: CircleAvatar(
          radius: radius,
          backgroundColor: backGroundColor ?? Colors.white,
          // child: Image.asset("assets/images/splash.png"),
        ),
      ),
      imageBuilder: (context, provider) {
        return Container(
          height: radius != null ? radius * 2 : null,
          width: radius != null ? radius * 2 : null,
          decoration: BoxDecoration(
              border: color != null ? Border.all(color: color, width: 1) : null,
              shape: BoxShape.circle),
          child: CircleAvatar(
            backgroundImage: provider,
            radius: radius,
            backgroundColor: backGroundColor ?? Colors.white,
          ),
        );
      },
    );
  }

  //Asset network Image
  Widget imageNewWorkImage(
      {String? image, String? defaultImage, double? height, double? width}) {
    return CachedNetworkImage(
      imageUrl: image == "" || image == null ? "https://" : image,
      errorWidget: (a, b, c) => Container(
        height: height ?? 40,
        width: width ?? 40,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: Image.asset(defaultImage ?? "assets/splash.png").image,
          ),
        ),
      ),
      placeholder: (context, url) => Container(
        height: height ?? 40,
        width: width ?? 40,
        decoration: const BoxDecoration(),
      ),
      imageBuilder: (context, provider) {
        return Container(
          height: height ?? 40,
          width: width ?? 40,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: provider,
            ),
          ),
        );
      },
    );
  }
}
