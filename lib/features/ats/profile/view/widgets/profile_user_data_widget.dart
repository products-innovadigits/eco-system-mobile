import 'package:eco_system/utility/export.dart';

class ProfileUserDataWidget extends StatelessWidget {
  final String cvUrl;

  const ProfileUserDataWidget({super.key, required this.cvUrl});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            PercentageAvatar(
                avatarPath: Assets.images.avatar.path, percentage: '10' , avatarSize: 64.w),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: 10.w, vertical: 8.h),
              decoration: BoxDecoration(
                  color: Styles.WHITE_COLOR,
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Images(
                      image: Assets.svgs.documentDownload.path,
                      color: Styles.PRIMARY_COLOR),
                  8.sw,
                  Text(
                    allTranslations.text(LocaleKeys.cv),
                    style: AppTextStyles.w500.copyWith(
                        color: Styles.PRIMARY_COLOR,
                        fontSize: 10),
                  )
                ],
              ),
            )
          ],
        ),
        10.sh,
        Text('هشام منصور',
            style: AppTextStyles.w600.copyWith(
                fontSize: 16, color: Styles.WHITE_COLOR)),
        6.sh,
        Text('مصمم أول لواجهة المستخدم',
            style: AppTextStyles.w400
                .copyWith(color: Styles.WHITE_COLOR)),
      ],
    );
  }
}
