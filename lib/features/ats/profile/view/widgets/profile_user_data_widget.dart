import 'package:eco_system/utility/export.dart';

class ProfileUserDataWidget extends StatelessWidget {
  final String cvUrl;
  final String name;
  final String email;
  final bool showAvatarPercentage;

  const ProfileUserDataWidget(
      {super.key, required this.cvUrl, required this.showAvatarPercentage, required this.name, required this.email});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            PercentageAvatar(
                avatarPath: Assets.images.avatar.path,
                percentage: '10',
                withPercentage: showAvatarPercentage,
                avatarSize: 64.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
              decoration: BoxDecoration(
                  color: Styles.WHITE_COLOR,
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'CV',
                    style: AppTextStyles.w500
                        .copyWith(color: Styles.PRIMARY_COLOR),
                  ),
                  8.sw,
                  Images(
                      image: Assets.svgs.documentDownload.path,
                      color: Styles.PRIMARY_COLOR),
                ],
              ),
            )
          ],
        ),
        10.sh,
        Text(name,
            style: AppTextStyles.w600
                .copyWith(fontSize: 16, color: Styles.WHITE_COLOR)),
        4.sh,
        Text(email,
            style: AppTextStyles.w400.copyWith(color: Styles.WHITE_COLOR)),
      ],
    );
  }
}
