import 'package:ats_package/shared/ats_exports.dart';
import 'package:core_package/core/utility/export.dart';

class ManagerReviewCardWidget extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback onExpand;

  const ManagerReviewCardWidget(
      {super.key, required this.isExpanded, required this.onExpand});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, AppState>(
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: context.color.outline)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: onExpand,
                child: Row(
                  children: [
                    Container(
                      width: 32.w,
                      height: 32.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: context.color.outline, width: 2),
                        image: DecorationImage(
                            image: AssetImage(Assets.images.avatar.path),
                            fit: BoxFit.fill),
                      ),
                    ),
                    8.sw,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'معاذ زهران',
                          style: AppTextStyles.w600
                              .copyWith(color: Styles.TEXT_COLOR, fontSize: 12),
                        ),
                        2.sh,
                        Text(
                          '4.5/5 ${allTranslations.text(LocaleKeys.degree)}',
                          style: AppTextStyles.w400
                              .copyWith(color: Styles.PRIMARY_COLOR,
                              fontSize: 9),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Images(
                        image: isExpanded
                            ? Assets.svgs.arrowUp.path
                            : Assets.svgs.arrowDown.path),
                  ],
                ),
              ),
              if (isExpanded)...[
                10.sh,
                Padding(
                  padding: EdgeInsetsDirectional.only(start: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('١- لقد اعطاة معاذ ٣ من ٥ في المهارات',
                          style: AppTextStyles.w400.copyWith(
                              color: Styles.SUB_TEXT_DARK_COLOR, fontSize: 10)),
                      8.sh,
                      Text('١- لقد اعطاة معاذ ٣ من ٥ في المهارات',
                          style: AppTextStyles.w400.copyWith(
                              color: Styles.SUB_TEXT_DARK_COLOR, fontSize: 10)),
                      8.sh,
                      Text('١- لقد اعطاة معاذ ٣ من ٥ في المهارات',
                          style: AppTextStyles.w400.copyWith(
                              color: Styles.SUB_TEXT_DARK_COLOR, fontSize: 10)),
                      8.sh,
                    ],
                  ),
                ),
              ]
            ],
          ),
        );
      },
    );
  }
}
