import 'package:strategy_system/bsc/bsc_perspective_home_mapper.dart';
import 'package:strategy_system/bsc/model/bsc_model.dart';
import 'package:strategy_system/objective_details/model/objective_indicator_model.dart';
import 'package:strategy_system/okr/model/okr_model.dart';

/// Demo OKRs for football club client — shared by [OkrView] and [OkrCardSection].
List<OkrObjectivesModel> okrFootballClubDemoObjectives() => [
      OkrObjectivesModel(
        title: 'تعزيز الأداء الرياضي للفريق الأول',
        keyResults: [
          IndicatorModel(
            title: 'الحفاظ على مراكز متقدمة في جدول الدوري',
            status: 'متقدم',
            percentage: '78',
          ),
          IndicatorModel(
            title: 'تحسين متوسط الأهداف المسجلة لكل مباراة',
            status: 'متقدم',
            percentage: '72',
          ),
          IndicatorModel(
            title: 'خفض معدل الإصابات الطويلة للاعبين',
            status: 'متأخر',
            percentage: '45',
          ),
        ],
        id: 1,
      ),
      OkrObjectivesModel(
        title: 'تطوير الأكاديمية ومسار المواهب',
        keyResults: [
          IndicatorModel(
            title: 'ضم لاعبين من قطاع الناشئين لتدريبات الفريق الأول',
            status: 'مكتمل',
            percentage: '100',
          ),
          IndicatorModel(
            title: 'توسيع برامج الاكتشاف في الأحياء والمدن الشريكة',
            status: 'متقدم',
            percentage: '68',
          ),
        ],
        id: 2,
      ),
      OkrObjectivesModel(
        title: 'تجربة مشجع عالية الجودة في الملعب ومنصات النادي',
        keyResults: [
          IndicatorModel(
            title: 'رفع مؤشر رضا الجماهير في مباريات الملعب',
            status: 'متقدم',
            percentage: '85',
          ),
          IndicatorModel(
            title: 'تحسين رحلة شراء التذاكر والخدمات الرقمية',
            status: 'متقدم',
            percentage: '62',
          ),
          IndicatorModel(
            title: 'زيادة معدلات إشغال المدرجات في المباريات الرسمية',
            status: 'متأخر',
            percentage: '38',
          ),
        ],
        id: 3,
      ),
    ];

const _kOkrDemoHomePalette = [
  '#175CD3',
  '#079455',
  '#DC6803',
  '#175CD3',
];

double? _averageKeyResultPercentage(OkrObjectivesModel o) {
  final krs = o.keyResults ?? [];
  final values = <double>[];
  for (final k in krs) {
    final p = parseIndicatorPercentage(k.percentage);
    if (p != null) values.add(p);
  }
  if (values.isEmpty) return null;
  return values.reduce((a, b) => a + b) / values.length;
}

/// Home card rows: same titles as demo OKRs, % = average of key-result percentages.
List<ObjectiveKPIModel> okrFootballClubDemoHomeCardRows() {
  final objectives = okrFootballClubDemoObjectives();
  return List.generate(objectives.length, (i) {
    final o = objectives[i];
    final avg = _averageKeyResultPercentage(o) ?? 0.0;
    return ObjectiveKPIModel(
      kpiTitle: o.title ?? '',
      value: avg.clamp(0.0, 100.0),
      color: _kOkrDemoHomePalette[i % _kOkrDemoHomePalette.length],
    );
  });
}
