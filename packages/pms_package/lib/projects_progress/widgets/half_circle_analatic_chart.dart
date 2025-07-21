import 'package:core_package/core/utility/export.dart';
import 'package:pms_package/projects_progress/model/project_progress_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HalfCircleAnalyticChart extends StatelessWidget {
  const HalfCircleAnalyticChart(this.projects, {super.key});

  final List<ProjectProgressModel> projects;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280.h,
      child: Column(
        children: [
          Expanded(
            child: SfCircularChart(
              // margin: EdgeInsets.zero,
              // annotations: _buildCenterAnnotation(projects, context),
              series: [
                DoughnutSeries<ProjectProgressModel, String>(
                  dataSource: projects,
                  xValueMapper: (d, _) => d.categoryName,
                  yValueMapper: (d, _) => d.value,
                  pointColorMapper: (d, _) =>
                      Styles.statusColors(d.categoryName ?? ''),
                  startAngle: 270,
                  endAngle: 90,
                  dataLabelMapper: (d, _) {
                    if (d.value == 0) {
                      return '';
                    } else {
                      return d.value.toString();
                    }
                  },
                  // or d.value.toInt()
                  dataLabelSettings: DataLabelSettings(
                    isVisible: true,
                    labelPosition: ChartDataLabelPosition.inside,
                    // put it in the slice
                    textStyle: context.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w700, color: LightColor.white),
                  ),
                  innerRadius: '60%',
                  radius: '100%',
                  // cornerStyle: CornerStyle.bothFlat,
                  strokeColor: LightColor.white,
                  strokeWidth: 3,
                  emptyPointSettings: EmptyPointSettings(
                    mode: EmptyPointMode.zero,
                  ),
                  animationDuration: 800,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
