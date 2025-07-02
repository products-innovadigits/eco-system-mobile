import 'package:core_package/core/utility/export.dart';

class CustomImageStack extends StatelessWidget {
  final List<String>? images;
  final Color? boarderColor;
  final double? radius;
  const CustomImageStack({
    super.key,
    this.images,
    this.boarderColor,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    if (images == null || images!.isEmpty) {
      return Container();
    } else {
      var widgetList = images!
          .sublist(0, images!.length)
          .asMap()
          .map((index, value) => MapEntry(
              index,
              Padding(
                padding: EdgeInsets.only(left: 0.7 * 20 * index),
                child: CustomNetworkImage.circleNewWorkImage(
                  image: value,
                  radius: radius ?? 12,
                  color: boarderColor ?? Colors.white,
                ),
              )))
          .values
          .toList();
      return Stack(
        clipBehavior: Clip.none,
        children: widgetList,
      );
    }
  }
}
