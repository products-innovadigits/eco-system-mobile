import 'package:core_system/core/widgets/main_card_widget.dart';

import '../../../core/pms_prototype_employees.dart';
import '../../../core/utility/pms_exports.dart';

class EmployeeOfTheMonthLandscapeCard extends StatelessWidget {
  final bool isPMSHome;

  const EmployeeOfTheMonthLandscapeCard({super.key, this.isPMSHome = false});

  @override
  Widget build(BuildContext context) {
    return MainCardWidget(
      title: allTranslations.text(LocaleKeys.top_employees),
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
            name: PmsPrototypePodiumDisplay.rank2FirstName,
            score: PmsPrototypePodiumDisplay.rank2ScoreLabel,
            avatarSize: 56,
            color: const Color(0xffC0C0C0),
          ),
          _PerformerItem(
            rank: 1,
            name: PmsPrototypePodiumDisplay.rank1FirstName,
            score: PmsPrototypePodiumDisplay.rank1ScoreLabel,
            avatarSize: 70,
            color: const Color(0xffE6C16B),
            isFirst: true,
          ),
          _PerformerItem(
            rank: 3,
            name: PmsPrototypePodiumDisplay.rank3FirstName,
            score: PmsPrototypePodiumDisplay.rank3ScoreLabel,
            avatarSize: 56,
            color: const Color(0xffCD7F32),
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
  final Color color;
  final bool isFirst;

  const _PerformerItem({
    required this.rank,
    required this.name,
    required this.score,
    required this.avatarSize,
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
                  border: Border.all(color: color, width: 3.5),
                ),
                child: CustomNetworkImage.circleNewWorkImage(
                  radius: avatarSize,
                  backGroundColor: context.color.primary,
                  padding: EdgeInsets.all(3),
                ),
              ),
              PositionedDirectional(
                top: -4,
                end: -2,
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    _rankLabel,
                    style: context.textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 4),
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
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 6),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
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
