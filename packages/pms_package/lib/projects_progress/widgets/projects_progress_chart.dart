import 'package:pms_package/shared/pms_exports.dart' hide ProjectProgressModel;

import '../model/project_progress_model.dart';

class ProjectsProgressChart extends StatefulWidget {
  const ProjectsProgressChart({super.key, required this.projects});

  final List<ProjectProgressModel> projects;

  @override
  State<ProjectsProgressChart> createState() => _ProjectsProgressChartState();
}

class _ProjectsProgressChartState extends State<ProjectsProgressChart> {
  int touchedIndex = -1;
  bool isEmpty = false;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.4,
      child: PieChart(
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
              show: false, border: Border.all(color: context.color.outline)),
          centerSpaceRadius: 0.w,
          sections: isEmpty || showingSections().isEmpty
              ? emptyState(context)
              : showingSections(),
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(widget.projects.length, (i) {
      final isTouched = i == touchedIndex;
      final radius = isTouched ? 110.w : 100.w;
      return PieChartSectionData(
        color: Styles.statusColors(widget.projects[i].categoryName ?? ""),
        // title: '${widget.objectives[i].value?.toStringAsFixed(2)}%',
        title: "",
        value: widget.projects[i].value ?? 0,
        radius: radius,
        borderSide: BorderSide(
          color: context.color.outline,
        ),
        badgeWidget: Container(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 10.h),
          decoration: BoxDecoration(
              border: Border.all(color: context.color.outline),
              color: context.color.surfaceContainer,
              shape: BoxShape.circle),
          child: Text(
            '${widget.projects[i].value?.toStringAsFixed(0)}%',
            style: context.textTheme.labelSmall
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        badgePositionPercentageOffset: 1.05,
      );
    });
  }

  emptyState(BuildContext context) {
    return [
      PieChartSectionData(
        color: context.color.surfaceContainer,
        title: "",
        value: 100,
        radius: 100.w,
        borderSide: BorderSide(color: context.color.surfaceContainer),
      )
    ];
  }
}
