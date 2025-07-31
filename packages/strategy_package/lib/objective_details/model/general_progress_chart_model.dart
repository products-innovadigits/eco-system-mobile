import 'package:core_package/core/utility/export.dart';

class GeneralProgressChartModel extends SingleMapper {
  List<YearPercent>? actual;
  List<YearPercent>? all;

  GeneralProgressChartModel({this.actual, this.all});


  GeneralProgressChartModel.fromJson(Map<String, dynamic> json) {
    if (json['initiatives'] != null) {
      actual = (json['initiatives'] as List)
          .map((e) => YearPercent.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    // Parse kpis list
    if (json['kpis'] != null) {
      all = (json['kpis'] as List)
          .map((e) => YearPercent.fromJson(e as Map<String, dynamic>))
          .toList();
    }
  }

  @override
  Map<String, dynamic> toJson() => {
    'initiatives': actual?.map((e) => e.toJson()).toList(),
    'kpis':        all?.map((e) => e.toJson()).toList(),
  };

  @override
  Mapper fromJson(Map<String, dynamic> json) =>
      GeneralProgressChartModel.fromJson(json);
}

class YearPercent {
  int? year;
  int? month;
  double? value;

  YearPercent({this.year, this.month, this.value});

  YearPercent.fromJson(Map<String, dynamic> json) {
    year   = json['year'];
    month  = json['month'];
    value  = double.tryParse(json['value']?.toString() ?? '0');
  }

  Map<String, dynamic> toJson() => {
    'year':  year,
    'month': month,
    'value': value,
  };
}
