import 'package:core_system/core/utility/export.dart';

Widget customImageIcon({
  String? folderPath,
  required String? imageName,
  String? imagePath,
  width,
  height,
  color,
}) {
  return Image.asset(
    'assets/${folderPath ?? "images"}/$imageName.${imagePath ?? "png"}',
    color: color,
    colorBlendMode: color != null ? BlendMode.srcIn : null,
    width: width ?? 30,
    height: height ?? 25,
  );
}

Widget customCircleSvgIcon({
  String? folderPath,
  String? title,
  required String? imageName,
  String? imagePath,
  Function? onTap,
  Color? color,
  Color backgroundColor = Styles.whiteColor,
  width,
  height,
  double radius = 25,
}) {
  return InkWell(
    onTap: () {
      onTap!();
    },
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundColor: backgroundColor,
          radius: radius,
          child: SvgPicture.asset(
            width: radius * 1.4,
            height: radius * 1.4,
            colorFilter: color != null
                ? ColorFilter.mode(color, BlendMode.srcIn)
                : null,
            'assets/svgs/$imageName.svg',
          ),
        ),
        Visibility(
          visible: title != null,
          child: Column(
            children: [
              const SizedBox(height: 2),
              Text(
                title ?? "",
                style: TextStyle(
                  color: LightColor.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget customImageIconSVG({
  required String? imageName,
  Color? color,
  double? height,
  width,
}) {
  return Images(
    image: 'assets/svgs/$imageName.svg',
    color: color,
    height: height,
    width: width,
  );
}
