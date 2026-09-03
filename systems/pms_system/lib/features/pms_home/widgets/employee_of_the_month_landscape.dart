import 'package:core_system/core/widgets/main_card_widget.dart';
import 'package:pms_system/core/di/pms_locator.dart';
import 'package:pms_system/features/employees_performance/bloc/employees_performance_bloc.dart';
import 'package:pms_system/features/employees_performance/bloc/employees_performance_events.dart';
import 'package:pms_system/features/employees_performance/bloc/employees_performance_states.dart';
import 'package:pms_system/features/employees_performance/model/employees_performance_model.dart';
import 'package:pms_system/features/pms_home/widgets/home_card_state_message.dart';

import '../../../core/utility/pms_exports.dart';

class EmployeeOfTheMonthLandscapeCard extends StatelessWidget {
  final bool isPMSHome;

  const EmployeeOfTheMonthLandscapeCard({super.key, this.isPMSHome = false});

  @override
  Widget build(BuildContext context) {
    if (isPMSHome) {
      return _CardContent(isPMSHome: isPMSHome);
    }
    return BlocProvider(
      create: (_) =>
          EmployeesPerformanceBloc(repo: pmsSl())
            ..add(const LoadPerformanceData()),
      child: _CardContent(isPMSHome: isPMSHome),
    );
  }
}

class _CardContent extends StatelessWidget {
  final bool isPMSHome;

  const _CardContent({required this.isPMSHome});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmployeesPerformanceBloc, EmployeesPerformanceState>(
      builder: (context, state) {
        final hasData = state is PerformanceLoaded && state.top3.isNotEmpty;
        return state is! PerformanceFailure
            ? MainCardWidget(
                title: allTranslations.text(LocaleKeys.top_employees),
                moreBtnTxt: isPMSHome && hasData
                    ? allTranslations.text(LocaleKeys.view_all)
                    : null,
                onViewMoreTap: !hasData
                    ? null
                    : () {
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
                child: switch (state) {
                  PerformanceLoading() => const _ShimmerContent(),
                  PerformanceLoaded(:final top3) when top3.isNotEmpty =>
                    _LoadedContent(top3: top3),
                  PerformanceLoaded() => HomeCardStateMessage(
                    message: allTranslations.text(LocaleKeys.there_is_no_data),
                  ),
                  // PerformanceFailure(:final message) => HomeCardStateMessage(
                  //   message: message,
                  //   isError: true,
                  // ),
                  _ => const SizedBox.shrink(),
                },
              )
            : const SizedBox.shrink();
      },
    );
  }
}

class _ShimmerContent extends StatelessWidget {
  const _ShimmerContent();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _ShimmerPodiumItem(avatarSize: 56),
        _ShimmerPodiumItem(avatarSize: 70),
        _ShimmerPodiumItem(avatarSize: 56),
      ],
    );
  }
}

class _ShimmerPodiumItem extends StatelessWidget {
  final double avatarSize;

  const _ShimmerPodiumItem({required this.avatarSize});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomShimmerCircleImage(radius: avatarSize),
        SizedBox(height: 4),
        CustomShimmerContainer(
          height: 12,
          width: 50,
          borderRadius: 4,
          padding: EdgeInsets.zero,
        ),
        SizedBox(height: 6),
        CustomShimmerContainer(
          height: 20,
          width: 50,
          borderRadius: 20,
          padding: EdgeInsets.zero,
        ),
      ],
    );
  }
}

class _LoadedContent extends StatelessWidget {
  final List<PerformanceEmployeeModel> top3;

  const _LoadedContent({required this.top3});

  @override
  Widget build(BuildContext context) {
    if (top3.isEmpty) return const SizedBox.shrink();

    final first = top3.length > 0 ? top3[0] : null;
    final second = top3.length > 1 ? top3[1] : null;
    final third = top3.length > 2 ? top3[2] : null;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (second != null)
          _PerformerItem(
            rank: 2,
            name: second.name ?? '',
            score: '${second.percentage?.toStringAsFixed(1) ?? '0'}%',
            avatarSize: 56,
            color: const Color(0xffC0C0C0),
          ),
        if (first != null)
          _PerformerItem(
            rank: 1,
            name: first.name ?? '',
            score: '${first.percentage?.toStringAsFixed(1) ?? '0'}%',
            avatarSize: 70,
            color: const Color(0xffE6C16B),
            isFirst: true,
          ),
        if (third != null)
          _PerformerItem(
            rank: 3,
            name: third.name ?? '',
            score: '${third.percentage?.toStringAsFixed(1) ?? '0'}%',
            avatarSize: 56,
            color: const Color(0xffCD7F32),
          ),
      ],
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
