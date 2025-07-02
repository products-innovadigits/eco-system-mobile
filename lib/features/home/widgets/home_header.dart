import 'package:core_package/core/helpers/font_sizes.dart';
import 'package:core_package/core/utility/export.dart';
import 'package:core_package/core/widgets/profile_image_widget.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, AppState>(
      builder: (context, state) {
        return Container(
          width: context.w,
          height: context.h * 0.30,
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 24.h),
          color: context.color.primary,
          // decoration:  BoxDecoration(
          //     image: DecorationImage(
          //         image: AssetImage(Assets.images.newHomeHeaderBg.path),
          //         fit: BoxFit.cover)
          // ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                35.sh,
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
                            " ${UserBloc.instance.user?.welcomeMessage ?? "صباح الخير "} ${DateTime.now().format("a") == "AM" ? "🌤" : "🌤"}",
                            style: context.textTheme.displaySmall
                                ?.copyWith(color: context.color.onPrimary),
                          ),
                          4.sh,
                          Text(
                            allTranslations.text("home_welcome_message"),
                            style: AppTextStyles.w400.copyWith(
                              fontSize: FontSizes.f14,
                              color: context.color.onPrimary,
                            ),
                          )
                        ],
                      ),
                    ),
                    8.sw,
                    ProfileImageWidget(radius: 22.w),
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
