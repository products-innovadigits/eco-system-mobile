import 'package:core_package/core/utility/export.dart';

class ObjectiveChartModel extends SingleMapper {
  double? objectValue;
  double? kpisValue;
  double? initiativesValue;
  int? year;
  int? month;

  ObjectiveChartModel(
      {this.objectValue,
      this.kpisValue,
      this.initiativesValue,
      this.year,
      this.month});

  ObjectiveChartModel.fromJson(Map<String, dynamic> json) {
    objectValue = double.tryParse(json['objectValue']?.toString() ?? "0");
    kpisValue = double.tryParse(json['kpisValue']?.toString() ?? "0");
    initiativesValue =
        double.tryParse(json['initiativesValue']?.toString() ?? "0");
    year = json['year'];
    month = json['month'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['objectValue'] = this.objectValue;
    data['kpisValue'] = this.kpisValue;
    data['initiativesValue'] = this.initiativesValue;
    data['year'] = this.year;
    data['month'] = this.month;
    return data;
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return ObjectiveChartModel.fromJson(json);
  }
}

enum ChartTime { Year, Month }
