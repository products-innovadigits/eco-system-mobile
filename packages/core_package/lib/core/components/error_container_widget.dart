
import 'package:core_package/core/utility/export.dart';

class ErrorContainerWidget extends StatelessWidget {
  final VoidCallback onTryAgain;
  final Widget? header;

  const ErrorContainerWidget(
      {super.key, required this.onTryAgain, this.header});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.w,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
          color: Styles.WHITE_COLOR,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: context.color.outline)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (header != null) ...[
            header!,
            12.sh,
          ],
          Text(allTranslations.text(LocaleKeys.something_went_wrong)),
          12.sh,
          InkWell(
            onTap: onTryAgain,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  allTranslations.text(LocaleKeys.try_again),
                  style: AppTextStyles.w400.copyWith(
                      color: Styles.SUB_TEXT_DARK_COLOR, fontSize: 12),
                ),
                8.sw,
                Icon(
                  Icons.refresh_outlined,
                  color: Styles.ICON_GREY_COLOR,
                  size: 18,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
