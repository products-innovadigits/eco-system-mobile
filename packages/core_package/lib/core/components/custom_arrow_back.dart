import 'package:core_package/core/utility/export.dart';

class ArrowBack extends StatelessWidget {
  const ArrowBack({super.key});

  @override
  Widget build(BuildContext context) {
    return allTranslations.currentLanguage == "ar"
        ? customImageIconSVG(imageName: "right")
        : customImageIconSVG(imageName: "left");
  }
}

class ArrowBackIos extends StatelessWidget {
  final Color color;
  const ArrowBackIos({super.key, this.color = Styles.HEADER});
  @override
  Widget build(BuildContext context) {
    return allTranslations.currentLanguage != "ar"
        ? customImageIconSVG(imageName: "ios-right", color: color)
        : customImageIconSVG(imageName: "ios-left", color: color);
  }
}
