import '../../shared/strategy_exports.dart';

class ObjectivePercentageChartMobileLandscape extends StatefulWidget {
  const ObjectivePercentageChartMobileLandscape({
    super.key,
    required this.objectives,
  });

  final List<ObjectivePercentageModel> objectives;

  @override
  State<ObjectivePercentageChartMobileLandscape> createState() =>
      _ObjectivePercentageChartMobileLandscapeState();
}

class _ObjectivePercentageChartMobileLandscapeState
    extends State<ObjectivePercentageChartMobileLandscape> {
  int touchedIndex = -1;
  bool isEmpty = true;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ObjectivePercentageBloc, AppState>(
      builder: (context, state) {
        if (state is Done) {
          isEmpty =
              double.parse((state.data as String).replaceAll('%', '')) <= 0;
        }
        return SizedBox(
          height: 220,
          child: Stack(
            alignment: Alignment.center,
            children: [
              PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex = pieTouchResponse
                            .touchedSection!
                            .touchedSectionIndex;
                      });
                    },
                  ),
                  borderData: FlBorderData(
                    show: false,
                    border: Border.all(color: context.color.outline),
                  ),
                  sectionsSpace: 5.w,
                  centerSpaceRadius: 25.w,
                  sections: isEmpty || showingSections().isEmpty
                      ? emptyState()
                      : showingSections(),
                ),
              ),
              BlocBuilder<ObjectivePercentageBloc, AppState>(
                builder: (context, state) {
                  if (state is Done) {
                    return FittedBox(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: allTranslations.text("objective_percentage"),
                          style: context.textTheme.labelSmall,
                          children: [
                            // TextSpan(
                            //   text: "\n${state.data ?? 0}",
                            //   style: context.textTheme.titleLarge?.copyWith(
                            //       color: isEmpty
                            //           ? context.color.outline
                            //           : context.color.primary),
                            // )
                          ],
                        ),
                      ),
                    );
                  }
                  if (state is Loading) {
                    return CustomShimmerContainer(width: 80.w, height: 16.h);
                  } else {
                    return SizedBox();
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(widget.objectives.length, (i) {
      final isTouched = i == touchedIndex;
      final double radius = isTouched ? 60 : 50;
      return PieChartSectionData(
        color: LightColor.statusColors(widget.objectives[i].categoryName ?? ""),
        // title: '${widget.objectives[i].value?.toStringAsFixed(2)}%',
        title: "",
        value: widget.objectives[i].value ?? 0,
        radius: radius,
        borderSide: BorderSide(color: context.color.outline),
        badgeWidget: Container(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 10.h),
          decoration: BoxDecoration(
            border: Border.all(color: context.color.outline),
            color: context.color.surfaceContainer,
            shape: BoxShape.circle,
          ),
          child: Text(
            '${widget.objectives[i].value?.toStringAsFixed(0)}%',
            style: AppTextStyles.w600.copyWith(
              fontSize: 12,
              color: Styles.header,
            ),
          ),
        ),
        badgePositionPercentageOffset: 1.15,
      );
    });
  }

  List<PieChartSectionData> emptyState() {
    return [
      PieChartSectionData(
        color: Styles.surface,
        title: "",
        value: 100,
        radius: 50,
        borderSide: BorderSide(color: Styles.surface),
      ),
    ];
  }
}
