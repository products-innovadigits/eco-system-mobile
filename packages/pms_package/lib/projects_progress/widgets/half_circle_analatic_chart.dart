import 'package:core_package/core/utility/export.dart';
import 'package:pms_package/project_categories_progress/model/projects_progress_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HalfCircleAnalyticChart extends StatelessWidget {
  const HalfCircleAnalyticChart(this.projects, {super.key});

  final List<ProjectsOverviewData> projects;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280.h,
      child: Column(
        children: [
          Expanded(
            child: SfCircularChart(
              series: [
                DoughnutSeries<ProjectsOverviewData, String>(
                  dataSource: projects,
                  xValueMapper: (d, _) => d.name,
                  yValueMapper: (d, _) => d.count,
                  pointColorMapper: (d, _) => Color(
                    int.parse(
                        d.hexColor?.replaceAll('#', '0xff') ?? '0xff000000'),
                  ),
                  startAngle: 270,
                  endAngle: 90,
                  dataLabelMapper: (d, _) {
                    if (d.percentage == 0) {
                      return '';
                    } else {
                      return '${d.percentage.toString()}%';
                    }
                  },
                  dataLabelSettings: DataLabelSettings(
                    isVisible: true,
                    labelPosition: ChartDataLabelPosition.inside,
                    textStyle: context.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w700, color: LightColor.white),
                  ),
                  innerRadius: '60%',
                  radius: '100%',
                  // strokeColor: LightColor.white,
                  // strokeWidth: 3,
                  emptyPointSettings:
                      EmptyPointSettings(mode: EmptyPointMode.zero),
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
