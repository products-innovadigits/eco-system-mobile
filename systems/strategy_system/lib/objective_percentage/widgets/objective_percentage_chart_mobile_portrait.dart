import '../../shared/strategy_exports.dart';

class ObjectivePercentageChartMobilePortrait extends StatefulWidget {
  const ObjectivePercentageChartMobilePortrait({
    super.key,
    required this.objectives,
  });

  final List<ObjectivePercentageModel> objectives;

  @override
  State<ObjectivePercentageChartMobilePortrait> createState() =>
      _ObjectivePercentageChartMobilePortraitState();
}

class _ObjectivePercentageChartMobilePortraitState
    extends State<ObjectivePercentageChartMobilePortrait> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    // Empty is derived from the categorized list itself rather than from the
    // separate totalPercentage call, so the pie never disagrees with its data.
    final bool isEmpty = widget.objectives.every((e) => (e.value ?? 0) <= 0);
    final sections = isEmpty ? emptyState() : showingSections();
    return AspectRatio(
      aspectRatio: 1.4,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PieChart(
            // fl_chart lerps between the old and new section lists, but
            // lays out badges from the target list. Switching between the
            // 1-section empty state and the real sections made the
            // animated data shorter than the badges -> RangeError in
            // badgeWidgetPaint. A new key per section count avoids the lerp.
            key: ValueKey(sections.length),
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
                    touchedIndex =
                        pieTouchResponse.touchedSection!.touchedSectionIndex;
                  });
                },
              ),
              borderData: FlBorderData(
                show: false,
                border: Border.all(color: context.color.outline),
              ),
              sectionsSpace: 5.w,
              centerSpaceRadius: 50.w,
              sections: sections,
            ),
          ),
          BlocBuilder<ObjectivePercentageBloc, AppState>(
            builder: (context, state) {
              if (state is Done) {
                return SizedBox(
                  width: 80.w,
                  child: FittedBox(
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
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(widget.objectives.length, (i) {
      final isTouched = i == touchedIndex;
      final radius = isTouched ? 60.w : 50.w;
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
            _formatPercent(widget.objectives[i].value ?? 0),
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

  /// A non-zero slice that rounds to 0 (e.g. 0.45) is shown as "<1%" so the
  /// badge doesn't say "0%" next to a visible slice.
  String _formatPercent(double value) =>
      value > 0 && value < 1 ? '<1%' : '${value.toStringAsFixed(0)}%';

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
