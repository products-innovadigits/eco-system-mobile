import 'package:project_management/core/utility/project_management_exports.dart';

class GeneralProgressChartModel extends SingleMapper {
  double? totalProgress;
  int? currentMonth;
  int? currentYear;
  List<ProgressItem>? monthProgress;
  List<ProgressItem>? yearProgress;

  GeneralProgressChartModel({
    this.totalProgress,
    this.currentMonth,
    this.currentYear,
    this.monthProgress,
    this.yearProgress,
  });

  GeneralProgressChartModel.fromJson(Map<String, dynamic> json) {
    totalProgress = (json['totalProgress'] as num?)?.toDouble();
    currentMonth = (json['currentMonth'] as num?)?.toInt();
    currentYear = (json['currentYear'] as num?)?.toInt();

    if (json['monthProgress'] != null && json['monthProgress'] is List) {
      monthProgress = <ProgressItem>[];
      for (var v in (json['monthProgress'] as List)) {
        monthProgress!.add(
          ProgressItem.fromJson((v as Map).cast<String, dynamic>()),
        );
      }
    }

    if (json['yearProgress'] != null && json['yearProgress'] is List) {
      yearProgress = <ProgressItem>[];
      for (var v in (json['yearProgress'] as List)) {
        yearProgress!.add(
          ProgressItem.fromJson((v as Map).cast<String, dynamic>()),
        );
      }
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalProgress'] = totalProgress;
    data['currentMonth'] = currentMonth;
    data['currentYear'] = currentYear;

    if (monthProgress != null) {
      data['monthProgress'] = monthProgress!.map((e) => e.toJson()).toList();
    } else {
      data['monthProgress'] = null;
    }

    if (yearProgress != null) {
      data['yearProgress'] = yearProgress!.map((e) => e.toJson()).toList();
    } else {
      data['yearProgress'] = null;
    }

    return data;
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return GeneralProgressChartModel.fromJson(json);
  }
}

class ProgressItem {
  int? month;
  int? year;
  double? progress;

  ProgressItem({this.month, this.year, this.progress});

  ProgressItem.fromJson(Map<String, dynamic> json) {
    month = (json['month'] as num?)?.toInt();
    year = (json['year'] as num?)?.toInt();
    progress = (json['progress'] as num?)?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['month'] = month;
    data['year'] = year;
    data['progress'] = progress;
    return data;
  }
}
