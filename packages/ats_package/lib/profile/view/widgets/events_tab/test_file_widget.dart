import 'package:core_package/core/utility/export.dart';

class TestFileWidget extends StatelessWidget {
  const TestFileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
          color: context.color.surfaceContainer,
          border: Border.all(color: context.color.outline),
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Images(
              image: Assets.svgs.file.path,
              color: context.color.primary),
          8.sw,
          Text(
            allTranslations.text(LocaleKeys.test_file),
            style: AppTextStyles.w500.copyWith(
                color: context.color.primary,
                fontSize: 10),
          )
        ],
      ),
    );
  }
}
