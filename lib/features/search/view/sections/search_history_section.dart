import 'package:eco_system/utility/export.dart';

class SearchHistorySection extends StatelessWidget {
  const SearchHistorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              allTranslations
                  .text(LocaleKeys.search_history),
              style: AppTextStyles.w400.copyWith(
                  color: Styles.SUB_TEXT_DARK_COLOR),
            ),
            Text(allTranslations.text(LocaleKeys.delete),
                style: AppTextStyles.w400.copyWith(
                    color: Styles.PRIMARY_COLOR,
                    fontSize: 12)),
          ],
        ),
        12.sh,
        ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 5,
            separatorBuilder: (context, index) => 16.sh,
            itemBuilder: (context, index) => Row(
              children: [
                Images(image: Assets.svgs.clock.path),
                8.sw,
                Text(
                  'قائد تصميم المنتجات ',
                  style: AppTextStyles.w400.copyWith(
                      color: Styles.TEXT_COLOR),
                ),
                const Spacer(),
                Images(
                    image:
                    Assets.svgs.arrowHistory.path)
              ],
            )),
      ],
    );
  }
}
