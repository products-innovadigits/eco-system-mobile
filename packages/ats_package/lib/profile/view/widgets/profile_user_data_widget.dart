import 'package:ats_package/shared/ats_exports.dart';
import 'package:core_package/core/utility/export.dart';

class ProfileUserDataWidget extends StatelessWidget {
  final String cvUrl;
  final String name;
  final String email;
  final bool showAvatarPercentage;

  const ProfileUserDataWidget({
    super.key,
    required this.cvUrl,
    required this.showAvatarPercentage,
    required this.name,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            PercentageAvatar(
              avatarPath: Assets.images.avatar2.path,
              percentage: '10',
              withPercentage: showAvatarPercentage,
              avatarSize: 64.w,
            ),
            if (cvUrl.isNotEmpty)
              GestureDetector(
                onTap: () => LauncherHelper.openUrl(cvUrl),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: context.color.surface,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Images(
                        image: Assets.svgs.downloadBox.path,
                        color: context.color.onSurface,
                      ),
                      8.sw,
                      Text('CV', style: context.textTheme.labelSmall),
                    ],
                  ),
                ),
              ),
          ],
        ),
        10.sh,
        Text(
          name,
          style: context.textTheme.titleLarge?.copyWith(
            color: context.color.onPrimary,
          ),
        ),
        4.sh,
        Text(
          email,
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.color.onPrimary,
          ),
        ),
      ],
    );
  }
}
