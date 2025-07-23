import 'package:core_package/core/utility/export.dart';

class KpisInitiativesProgressModel extends SingleMapper {
  String? objective;
  double? kpisValue;
  double? initiativesValue;
  // int? year;
  // int? month;

  KpisInitiativesProgressModel({
    this.objective,
    this.kpisValue,
    this.initiativesValue,
    // this.year,
    // this.month,
  });

  KpisInitiativesProgressModel.fromJson(Map<String, dynamic> json) {
    objective = json['objectValue']?.toString();
    kpisValue = double.tryParse(json['kpisValue']?.toString() ?? "0");
    initiativesValue = double.tryParse(
      json['initiativesValue']?.toString() ?? "0",
    );
    // year = json['year'];
    // month = json['month'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['objectValue'] = objective;
    data['kpisValue'] = kpisValue;
    data['initiativesValue'] = initiativesValue;
    // data['year'] = year;
    // data['month'] = month;
    return data;
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return KpisInitiativesProgressModel.fromJson(json);
  }
}

enum ChartTime { Year, Month }
