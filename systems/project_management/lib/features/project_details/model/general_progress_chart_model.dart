import 'package:project_management/core/utility/pms_exports.dart';

class GeneralProgressChartModel extends SingleMapper {
  int? projectId;
  String? type;
  int? totalOutputs;
  List<ProgressSeriesItem>? series;
  ProgressSeriesItem? latest;

  GeneralProgressChartModel({
    this.projectId,
    this.type,
    this.totalOutputs,
    this.series,
    this.latest,
  });

  GeneralProgressChartModel.fromJson(Map<String, dynamic> json) {
    projectId = (json['projectId'] as num?)?.toInt();
    type = json['type'];
    totalOutputs = (json['totalOutputs'] as num?)?.toInt();
    if (json['series'] != null && json['series'] is List) {
      series = <ProgressSeriesItem>[];
      for (var v in (json['series'] as List)) {
        series!.add(
          ProgressSeriesItem.fromJson((v as Map).cast<String, dynamic>()),
        );
      }
    }
    latest = json['latest'] == null
        ? null
        : ProgressSeriesItem.fromJson(
            (json['latest'] as Map).cast<String, dynamic>(),
          );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['projectId'] = projectId;
    data['type'] = type;
    data['totalOutputs'] = totalOutputs;
    if (series != null) {
      data['series'] = series!.map((e) => e.toJson()).toList();
    }
    if (latest != null) {
      data['latest'] = latest!.toJson();
    }
    return data;
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return GeneralProgressChartModel.fromJson(json);
  }
}

class ProgressSeriesItem {
  String? period;
  int? delivered;
  int? percent;

  ProgressSeriesItem({this.period, this.delivered, this.percent});

  ProgressSeriesItem.fromJson(Map<String, dynamic> json) {
    period = json['period'];
    delivered = (json['delivered'] as num?)?.toInt();
    percent = (json['percent'] as num?)?.toInt();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['period'] = period;
    data['delivered'] = delivered;
    data['percent'] = percent;
    return data;
  }
}
