import 'package:core_package/core/utility/export.dart';
import 'package:intl/intl.dart';
import 'package:strategy_package/objective_details/model/objective_chart_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ObjectiveBarChartSyncfusion extends StatelessWidget {
  final List<ObjectiveChartModel> data;

  const ObjectiveBarChartSyncfusion({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final tooltipBehavior = TooltipBehavior(
      enable: true,
      header: '',
      canShowMarker: false,
      format: 'point.y',
      textStyle: context.textTheme.labelMedium?.copyWith(
        color: LightColor.white,
        fontWeight: FontWeight.w600,
      ),
      color: context.color.primary,
    );

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      reverse: true,
      child: SizedBox(
        width: (data.length == 1) ? 300.w : context.w,
        child: SfCartesianChart(
          tooltipBehavior: tooltipBehavior,
          // legend: Legend(
          //   isVisible: true,
          //   position: LegendPosition.bottom,
          //   overflowMode: LegendItemOverflowMode.wrap,
          // ),
          primaryXAxis: CategoryAxis(
            majorGridLines: MajorGridLines(width: 2),
            axisLine: AxisLine(width: 1),
            majorTickLines: MajorTickLines(size: 5),
            borderColor: context.color.outline,
          ),
          primaryYAxis: NumericAxis(
            minimum: 0,
            maximum: 100,
            interval: 20,
            numberFormat: NumberFormat("##'%'"),
            axisLine: AxisLine(width: 1),
            majorTickLines: MajorTickLines(size: 5),
            borderColor: context.color.outline,
          ),
          series: [
            ColumnSeries<ObjectiveChartModel, String>(
              dataSource: data,
              xValueMapper: (m, _) => m.year.toString(),
              yValueMapper: (m, _) => m.objectValue,
              color: context.color.secondary,
              width: 0.15,
              borderRadius: BorderRadius.circular(8),
              borderColor: LightColor.white,
              borderWidth: 2,
              animationDuration: 800,
              // pointWidth: 12,
            ),

            StackedColumnSeries<ObjectiveChartModel, String>(
              dataSource: data,
              xValueMapper: (m, _) => m.year.toString(),
              yValueMapper: (m, _) => m.initiativesValue,
              color: context.color.primary,
              width: 0.15,
              borderRadius: BorderRadius.circular(8),
              borderColor: LightColor.white,
              borderWidth: 2,
              animationDuration: 800,
              // pointWidth: 12,
            ),
            StackedColumnSeries<ObjectiveChartModel, String>(
              dataSource: data,
              xValueMapper: (m, _) => m.year.toString(),
              yValueMapper: (m, _) => m.kpisValue,
              color: context.color.tertiary,
              width: 0.15,
              borderRadius: BorderRadius.circular(8),
              borderColor: LightColor.white,
              borderWidth: 2,
              animationDuration: 800,
              // pointWidth: 12,
            ),
          ],
        ),
      ),
    );
  }
}
