import 'package:core_package/core/helpers/font_sizes.dart';
import 'package:core_package/core/utility/export.dart';

class EmptyContainer extends StatelessWidget {
  final String? img;
  final String? txt;
  final String? desc;
  final double? remain;
  final TextStyle? subStyle;

  const EmptyContainer({
    super.key,
    this.img,
    this.txt,
    this.remain = 200.0,
    this.desc,
    this.subStyle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQueryHelper.height - remain!,
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Images(image: img ?? Assets.svgs.emptyBox.path),
              const SizedBox(height: 24),
              Text(
                txt ?? allTranslations.text(LocaleKeys.there_is_no_data),
                textAlign: TextAlign.center,
                style: context.textTheme.titleLarge?.copyWith(
                  fontSize: FontSizes.f16,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                desc ?? "",
                textAlign: TextAlign.center,
                style:
                    subStyle ??
                    context.textTheme.bodySmall?.copyWith(
                      color: context.color.outlineVariant,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
