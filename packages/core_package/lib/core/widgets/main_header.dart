import 'package:core_package/core/utility/export.dart';
import 'package:core_package/core/widgets/profile_image_widget.dart';

class MainHeader extends StatelessWidget {
  final bool? withBackButton;

  const MainHeader({super.key, this.withBackButton = true});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, AppState>(
      builder: (context, state) {
        return Container(
          width: context.w,
          height: 210.h,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          // color: context.color.primary,
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
                withBackButton == true
                    ? Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () => CustomNavigator.pop(),
                              child: Images(
                                image: Assets.svgs.arrowBack.path,
                                color: LightColor.white,
                              ),
                            ),
                          ],
                        ),
                      )
                    : 50.sh,
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // RichText(
                          //   text: TextSpan(
                          //     text: allTranslations.text(
                          //         DateTime.now().format("a") == "AM"
                          //             ? "morning"
                          //             : "evening"),
                          //     style: AppTextStyles.w700.copyWith(
                          //         fontSize: 24, color: Styles.WHITE_COLOR),
                          //     children: [
                          //       TextSpan(
                          //         text:
                          //             // " ${allTranslations.text("mr/")} ${UserBloc.instance.user?.name ?? "Name"} ${DateTime.now().format("a") == "AM" ? "🌤" : "🌤"}",
                          //             " ${UserBloc.instance.user?.welcomeMessage} ${DateTime.now().format("a") == "AM" ? "🌤" : "🌤"}",
                          //         style: AppTextStyles.w700.copyWith(
                          //             fontSize: 24, color: Styles.WHITE_COLOR),
                          //       )
                          //     ],
                          //   ),
                          // ),
                          Text(
                            " ${UserBloc.instance.userModel?.welcomeMessage ?? "صباح الخير "} ${DateTime.now().format("a") == "AM" ? "🌤" : "🌤"}",
                            style: context.textTheme.displaySmall?.copyWith(
                              color: context.color.onPrimary,
                            ),
                          ),
                          4.sh,
                          Text(
                            allTranslations.text("home_welcome_message"),
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: context.color.onPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    8.sw,
                    ProfileImageWidget(radius: 20.w),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
