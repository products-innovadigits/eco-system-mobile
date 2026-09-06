import 'package:core_system/core/utility/export.dart';
import 'package:responsive_builder/responsive_builder.dart';

class MainHeader extends StatelessWidget {
  final bool? withBackButton;

  const MainHeader({super.key, this.withBackButton = true});

  /// How far the first body card is pulled up over the header.
  static const double cardOverlap = 24;

  /// Header height for a given screen type / orientation.
  /// Shared with the bodies that are stacked underneath it so both stay in
  /// sync when the header grows.
  static double resolveHeight(
    DeviceScreenType deviceType,
    Orientation orientation,
  ) {
    if (deviceType == DeviceScreenType.tablet) {
      return orientation == Orientation.portrait ? 220 : 200;
    }
    if (deviceType == DeviceScreenType.mobile) {
      return orientation == Orientation.portrait ? 170 : 160;
    }
    return 180;
  }

  /// Top spacing a stacked body must leave so its first card overlaps the
  /// header by [cardOverlap]. The body's own `SafeArea` already consumes the
  /// status-bar inset, so it is subtracted here.
  static double bodyTopOffset(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final height = resolveHeight(
      getDeviceType(mediaQuery.size),
      mediaQuery.orientation,
    );
    final offset = height - mediaQuery.padding.top - cardOverlap;
    return offset < 0 ? 0 : offset;
  }

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
    final double height = resolveHeight(deviceType, orientation);

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
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SystemSelectionWidget(),
                    SizedBox(width: 16.w),
                    InkWell(
                      onTap: () async {
                        await SharedHelper.sharedHelper?.logout(
                          navigateTo: Routes.LOGIN,
                        );
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Icon(Icons.logout, color: context.color.onPrimary),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
