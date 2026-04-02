import 'package:core_system/core/utility/export.dart';
import 'package:responsive_builder/responsive_builder.dart';

class MainHeader extends StatelessWidget {
  final bool? withBackButton;

  const MainHeader({super.key, this.withBackButton = true});

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
            // withBackButton == true
            //     ? Padding(
            //         padding: const EdgeInsets.only(top: 10, bottom: 15),
            //         child: Row(
            //           mainAxisAlignment: MainAxisAlignment.start,
            //           children: [
            //             InkWell(
            //               onTap: () => CustomNavigator.pop(),
            //               child: Images(
            //                 image: Assets.svgs.arrowBack.path,
            //                 color: LightColor.white,
            //               ),
            //             ),
            //           ],
            //         ),
            //       )
            //     : const SizedBox(height: 25),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        " صباح الخير ${UserBloc.instance.userModel?.name ?? "صباح الخير "} "
                        // " ${UserBloc.instance.userModel?.welcomeMessage ?? "صباح الخير "} "
                        "${DateTime.now().format("a") == "AM" ? "🌤" : "🌤"}",
                        style: context.textTheme.headlineSmall?.copyWith(
                          color: context.color.onPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                if (UserBloc.activeSystems.length > 1) SystemSelectionWidget(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
