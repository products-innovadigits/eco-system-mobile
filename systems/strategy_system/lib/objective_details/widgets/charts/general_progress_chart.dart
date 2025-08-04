import 'package:intl/intl.dart';
import 'package:strategy_system/objective_details/model/general_progress_chart_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../shared/strategy_exports.dart';

class GeneralProgressChart extends StatefulWidget {
  final GeneralProgressChartModel data;
  final bool isMonthly;

  const GeneralProgressChart({
    super.key,
    required this.data,
    this.isMonthly = false,
  });

  @override
  State<GeneralProgressChart> createState() => _GeneralProgressChartState();
}

class _GeneralProgressChartState extends State<GeneralProgressChart> {
  late final TooltipBehavior _tooltip;

  @override
  void initState() {
    super.initState();
    _tooltip = TooltipBehavior(
      enable: true,
      activationMode: ActivationMode.singleTap,
      canShowMarker: false,
      builder: _customTooltipBuilder,
    );
  }

  Widget _customTooltipBuilder(
    dynamic data,
    dynamic point,
    dynamic series,
    int pointIndex,
    int seriesIndex,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF001244),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '${data.value.toStringAsFixed(0)}%',
        style: const TextStyle(color: Colors.white, fontSize: 13),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      tooltipBehavior: _tooltip,
      // plotAreaBorderWidth: 0,
      // legend: const Legend(isVisible: false),
      zoomPanBehavior: ZoomPanBehavior(
        enablePanning: true,
        zoomMode: ZoomMode.x,
      ),

      primaryXAxis: NumericAxis(
        isInversed: true,
        // minimum: 1,
        // maximum: 12,
        interval: 1,
        autoScrollingDelta: widget.isMonthly ? 8 : 10,
        autoScrollingMode: AutoScrollingMode.start,
        numberFormat: NumberFormat("##"),
        labelIntersectAction: AxisLabelIntersectAction.wrap,
        axisLine: AxisLine(width: 1, color: context.color.outline),
        labelStyle: context.textTheme.bodySmall?.copyWith(
          color: context.color.outlineVariant,
          fontSize: 10,
        ),
      ),

      primaryYAxis: NumericAxis(
        opposedPosition: true,
        minimum: 0,
        maximum: 100,
        interval: 20,
        axisLine: AxisLine(width: 1, color: context.color.outline),
        majorTickLines: const MajorTickLines(size: 0),
        numberFormat: NumberFormat("##'%'"),
        labelStyle: context.textTheme.bodySmall?.copyWith(
          color: context.color.outlineVariant,
          fontSize: 10,
        ),
      ),

      series: <SplineSeries<YearPercent, num>>[
        SplineSeries<YearPercent, num>(
          dataSource: widget.data.actual ?? [],
          xValueMapper: (p, _) {
            if (widget.isMonthly) {
              return p.month ?? 0;
            }
            return p.year;
          },
          yValueMapper: (p, _) => p.value ?? 0,
          color: const Color(0xFF1F77FF),
          width: 4,
        ),

        SplineSeries<YearPercent, num>(
          dataSource: widget.data.all ?? [],
          xValueMapper: (p, _) {
            if (widget.isMonthly) {
              return p.month ?? 0;
            }
            return p.year;
          },
          yValueMapper: (p, _) => p.value ?? 0,
          color: const Color(0xFF001244),
          width: 4,
          markerSettings: const MarkerSettings(isVisible: false),
        ),
      ],
    );
  }
}
