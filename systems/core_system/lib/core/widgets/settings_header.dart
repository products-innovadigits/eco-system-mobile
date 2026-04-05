import 'package:core_system/core/utility/export.dart';
import 'package:responsive_builder/responsive_builder.dart';

/// Header for the settings screen: same shell as [MainHeader] (background, sizing)
/// but shows user icon + name, optional system switcher, and edit (no greeting, no bell).
class SettingsHeader extends StatelessWidget {
  const SettingsHeader({super.key, this.onEditPressed});

  final VoidCallback? onEditPressed;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, AppState>(
      builder: (context, state) {
        return ResponsiveBuilder(
          builder: (context, sizingInformation) {
            final deviceType = sizingInformation.deviceScreenType;

            return OrientationLayoutBuilder(
              portrait: (_) =>
                  _buildHeader(context, deviceType, Orientation.portrait),
              landscape: (_) =>
                  _buildHeader(context, deviceType, Orientation.landscape),
            );
          },
        );
      },
    );
  }

  Widget _buildHeader(
    BuildContext context,
    DeviceScreenType deviceType,
    Orientation orientation,
  ) {
    double height = 180;
    if (deviceType == DeviceScreenType.tablet) {
      height = orientation == Orientation.portrait ? 220 : 200;
    } else if (deviceType == DeviceScreenType.mobile) {
      height = orientation == Orientation.portrait ? 170 : 160;
    }

    final name = UserBloc.instance.userModel?.name;
    final displayName = (name != null && name.trim().isNotEmpty)
        ? name.trim()
        : allTranslations.text(LocaleKeys.username);

    return Container(
      width: context.w,
      height: height,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Assets.images.newHomeHeaderBg.path),
          fit: BoxFit.cover,
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 30),
            Row(
              children: [
                InkWell(
                  onTap: () {
                    CustomNavigator.pop();
                  },
                  child: Assets.svgs.arrowBack.svg(
                    color: LightColor.white,
                    width: 24,
                    height: 24,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(4.w),
                  width: 35.w,
                  height: 35.w,
                  decoration: BoxDecoration(
                    color: LightColor.white,
                    shape: BoxShape.circle,
                  ),
                  child: Images(image: Assets.svgs.user.path),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    displayName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.headlineSmall?.copyWith(
                      color: context.color.onPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                InkWell(
                  onTap: onEditPressed,
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: Images(
                      image: Assets.svgs.editOutline.path,
                      color: LightColor.white,
                      width: 24,
                      height: 24,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
