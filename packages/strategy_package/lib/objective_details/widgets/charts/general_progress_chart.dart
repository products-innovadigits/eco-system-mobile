import 'package:intl/intl.dart';
import 'package:strategy_package/objective_details/model/general_progress_chart_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../shared/strategy_exports.dart';

class GeneralProgressChart extends StatefulWidget {
  final GeneralProgressChartModel data;
  const GeneralProgressChart({super.key, required this.data});

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

  /// Dark rounded-rect tooltip “60 %”
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
      /// X-axis (Months 1–12)
      primaryXAxis: NumericAxis(
        isInversed: true,        // Dec on the left, Jan on the right
        minimum: 1,
        maximum: 12,
        interval: 1,
        autoScrollingDelta: 8,
        autoScrollingMode: AutoScrollingMode.start,
        labelIntersectAction: AxisLabelIntersectAction.wrap,
        axisLine: AxisLine(width: 1, color: context.color.outline),
        labelStyle: context.textTheme.bodySmall?.copyWith(
          color: context.color.outlineVariant,
          fontSize: 10,
        ),
      ),

      /// Y-axis (Percent)
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

      /// Two lines: actual (blue) & all (dark)
      series: <SplineSeries<YearPercent, int>>[
        // Upper blue line – actual
        SplineSeries<YearPercent, int>(
          dataSource: widget.data.actual ?? [],
          xValueMapper: (p, _) => p.month ?? 0,
          yValueMapper: (p, _) => p.value ?? 0,
          color: const Color(0xFF1F77FF),
          width: 4,
        ),

        // Lower dark line – all
        SplineSeries<YearPercent, int>(
          dataSource: widget.data.all ?? [],
          xValueMapper: (p, _) => p.month ?? 0,
          yValueMapper: (p, _) => p.value ?? 0,
          color: const Color(0xFF001244),
          width: 4,
          markerSettings: const MarkerSettings(isVisible: false),
        ),
      ],
    );
  }
}
