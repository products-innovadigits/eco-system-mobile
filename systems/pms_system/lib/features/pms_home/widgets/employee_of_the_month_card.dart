import 'package:core_system/core/widgets/main_card_widget.dart';

import '../../../core/utility/pms_exports.dart';

class EmployeeOfTheMonthCard extends StatelessWidget {
  final bool isPMSHome;

  const EmployeeOfTheMonthCard({super.key, this.isPMSHome = false});

  @override
  Widget build(BuildContext context) {
    return MainCardWidget(
      title: allTranslations.text(LocaleKeys.top_employees),
      // moreBtnTxt: allTranslations.text(LocaleKeys.view_all),
      // onViewMoreTap: () {
      //   CustomNavigator.push(Routes.EMPLOYEES_PERFORMANCE);
      // },
      moreBtnTxt: isPMSHome ? allTranslations.text(LocaleKeys.view_all) : null,
      onViewMoreTap: () {
        if (!isPMSHome) {
          UserBloc.currentActiveSystem = ActiveSystemEnum.pms;
        }
        isPMSHome
            ? CustomNavigator.push(Routes.EMPLOYEES_PERFORMANCE)
            : CustomNavigator.push(
                Routes.SYSTEM_SWITCHER,
                arguments: ActiveSystemEnum.pms,
              );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _PerformerItem(
            rank: 2,
            name: 'Mohamed',
            score: '98.2%',
            avatarSize: 70,
            color: const Color(0xffC0C0C0),
            // scoreTextColor: const Color(0xffBFC1C2),
            // borderColor: const Color(0xffA0AEC0),
            // badgeColor: const Color(0xffA0AEC0),
            // scoreBgColor: const Color(0xffEDF2F7),
            // scoreTextColor: const Color(0xff4A5568),
          ),
          _PerformerItem(
            rank: 1,
            name: 'Sarah',
            score: '99.8%',
            avatarSize: 90,
            color: const Color(0xffE6C16B),
            // scoreTextColor: const Color(0xffFFC107),
            // borderColor: LightColor.warning,
            // badgeColor: LightColor.warning,
            // scoreBgColor: const Color(0xffFEF3C7),
            // scoreTextColor: LightColor.warning,
            isFirst: true,
          ),
          _PerformerItem(
            rank: 3,
            name: 'David',
            score: '97.5%',
            avatarSize: 70,
            color: const Color(0xffCD7F32),
            // scoreTextColor: const Color(0xffFFC107),
            // borderColor: const Color(0xffE8722B),
            // badgeColor: const Color(0xffE8722B),
            // scoreBgColor: const Color(0xffFEEDD8),
            // scoreTextColor: const Color(0xffE8722B),
          ),
        ],
      ),
    );
  }
}

class _PerformerItem extends StatelessWidget {
  final int rank;
  final String name;
  final String score;
  final double avatarSize;

  // final Color borderColor;
  // final Color badgeColor;
  // final Color scoreBgColor;
  // final Color scoreTextColor;
  final Color color;
  final bool isFirst;

  const _PerformerItem({
    required this.rank,
    required this.name,
    required this.score,
    required this.avatarSize,
    // required this.borderColor,
    // required this.badgeColor,
    // required this.scoreBgColor,
    // required this.scoreTextColor,
    required this.color,
    this.isFirst = false,
  });

  String get _rankLabel {
    switch (rank) {
      case 1:
        return '1st';
      case 2:
        return '2nd';
      case 3:
        return '3rd';
      default:
        return '${rank}th';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: avatarSize + 4,
          height: avatarSize + 4,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Container(
                width: avatarSize,
                height: avatarSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: color, width: 5),
                ),
                child: CustomNetworkImage.circleNewWorkImage(
                  radius: avatarSize,
                  backGroundColor: context.color.primary,
                  padding: EdgeInsets.all(4),
                ),
              ),
              PositionedDirectional(
                top: -4,
                end: -2,
                child: Container(
                  width: 30.w,
                  height: 30.w,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    _rankLabel,
                    style: context.textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          name,
          style: isFirst
              ? context.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: context.color.onSurface,
                )
              : context.textTheme.bodySmall?.copyWith(
                  color: context.color.onSurface,
                ),
        ),
        SizedBox(height: 12.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color),
          ),
          child: Text(
            score,
            style: context.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
