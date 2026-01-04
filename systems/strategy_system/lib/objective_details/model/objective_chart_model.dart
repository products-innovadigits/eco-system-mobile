import 'package:core_system/core/utility/export.dart';

class ObjectiveChartModel extends SingleMapper {
  double? objectValue;
  double? kpisValue;
  double? initiativesValue;
  int? year;
  int? month;

  ObjectiveChartModel({
    this.objectValue,
    this.kpisValue,
    this.initiativesValue,
    this.year,
    this.month,
  });

  ObjectiveChartModel.fromJson(Map<String, dynamic> json) {
    objectValue = double.tryParse(json['objectValue']?.toString() ?? "0");
    kpisValue = double.tryParse(json['kpisValue']?.toString() ?? "0");
    initiativesValue = double.tryParse(
      json['initiativesValue']?.toString() ?? "0",
    );
    year = json['year'];
    month = json['month'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['objectValue'] = objectValue;
    data['kpisValue'] = kpisValue;
    data['initiativesValue'] = initiativesValue;
    data['year'] = year;
    data['month'] = month;
    return data;
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return ObjectiveChartModel.fromJson(json);
  }
}

enum ChartTime { year, month }
