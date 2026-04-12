import 'package:strategy_system/bsc/model/bsc_model.dart';

/// Same axes as [StrategicAxesSection]: API `strategicAxises`, or
/// [footballClubDemoStrategicAxes] when the API returns none.
List<StrategicAxisModel> effectiveStrategicAxesList(VisionDataModel? vision) {
  final api = vision?.strategicAxises ?? [];
  if (api.isNotEmpty) return api;
  return footballClubDemoStrategicAxes();
}

/// Number of objectives shown for that axis on [StrategicAxesView]
/// (API-linked objectives, else demo fallback per axis index).
int strategicAxisObjectiveCount(VisionDataModel? vision, int axisIndex) {
  final v = vision ?? VisionDataModel();
  return resolveStrategicAxisObjectives(v, axisIndex).length;
}

/// Demo strategic axes (football club) — same three themes as
/// [footballClubStrategicAxisDemoObjectives] indices 0–2. Used when the API
/// returns no `strategicAxises` so [StrategicAxesSection] chips/descriptions
/// stay aligned with [resolveStrategicAxisObjectives].
List<StrategicAxisModel> footballClubDemoStrategicAxes() => [
      StrategicAxisModel(
        id: 1,
        title: 'الأداء والنتائج الرياضية',
        description:
            'مؤشرات الفريق الأول: النقاط والأهداف والإصابات والجاهزية البدنية — يطابق أهداف رفع الجاهزية وتقليل الغياب الطويل في قائمة الأهداف أدناه.',
        colorCode: '#175CD3',
        isShow: true,
      ),
      StrategicAxisModel(
        id: 2,
        title: 'الأكاديمية وتطوير المواهب',
        description:
            'قاعدة الناشئين والاكتشاف والصعود بين الفئات العمرية — يطابق أهداف توسيع المواهب وبرامج الاكتشاف في القسم التالي.',
        colorCode: '#079455',
        isShow: true,
      ),
      StrategicAxisModel(
        id: 3,
        title: 'الجماهير والتجربة الرقمية',
        description:
            'تجربة الملعب والتذاكر والقنوات الرقمية والتفاعل مع المشجعين — يطابق أهداف رضا الجماهير والنمو الرقمي في القسم التالي.',
        colorCode: '#DC6803',
        isShow: true,
      ),
    ];

/// Objectives under [manzors] whose [ObjectActiveModel.strategicAxisId] matches
/// `strategicAxises[axisIndex].id` (same linkage implied by the BSC dashboard model).
List<ObjectActiveModel> objectivesForStrategicAxisIndex(
  VisionDataModel vision,
  int axisIndex,
) {
  final axes = vision.strategicAxises ?? [];
  if (axes.isEmpty || axisIndex < 0 || axisIndex >= axes.length) {
    return const [];
  }
  final axisId = axes[axisIndex].id;
  if (axisId == null) return const [];

  final out = <ObjectActiveModel>[];
  for (final m in vision.manzors ?? []) {
    for (final o in m.objectives ?? []) {
      if (o.strategicAxisId == axisId) {
        out.add(o);
      }
    }
  }
  return out;
}

/// Football-club demo objectives when the API returns no objectives for the selected axis.
List<ObjectActiveModel> footballClubStrategicAxisDemoObjectives(int axisIndex) {
  final i = axisIndex < 0 ? 0 : axisIndex % 3;
  switch (i) {
    case 0:
      return [
        ObjectActiveModel(
          id: 101,
          title: 'رفع جاهزية الفريق الأول للمنافسة المحلية والقارية',
          description: 'متابعة اللياقة البدنية ودورات الإحماء والتعافي',
          strategicAxisId: 1,
          kpIs: [
            IndicatorModel(
              title: 'متوسط النقاط في آخر خمس مباريات',
              status: 'متقدم',
              percentage: '76',
            ),
            IndicatorModel(
              title: 'معدل الأهداف المسجلة للمباراة',
              status: 'متقدم',
              percentage: '72',
            ),
          ],
          initiatives: [
            IndicatorModel(
              title: 'برنامج تغذية رياضية موحد للفريق',
              description: 'متابعة يومية مع الطاقم الطبي',
            ),
          ],
        ),
        ObjectActiveModel(
          id: 102,
          title: 'تقليل غياب اللاعبين بسبب الإصابة',
          description: 'تحليل أحمال التدريب والوقاية',
          strategicAxisId: 1,
          kpIs: [
            IndicatorModel(
              title: 'عدد أيام الغياب الطويل للاعبين الأساسيين',
              status: 'متأخر',
              percentage: '48',
            ),
          ],
          initiatives: [
            IndicatorModel(
              title: 'عيادة علاج طبيعي موسعة',
              description: 'جلسات يومية بعد التدريبات',
            ),
          ],
        ),
      ];
    case 1:
      return [
        ObjectActiveModel(
          id: 201,
          title: 'توسيع قاعدة المواهب في قطاع الناشئين',
          description: 'كشافون ومراكز تجارب في مناطق جديدة',
          strategicAxisId: 2,
          kpIs: [
            IndicatorModel(
              title: 'عدد اللاعبين المرتبطين بعقود تدريب احترافي',
              status: 'متقدم',
              percentage: '68',
            ),
            IndicatorModel(
              title: 'نسبة الصعود من فئات عمرية لأعلى',
              status: 'مكتمل',
              percentage: '100',
            ),
          ],
          initiatives: [
            IndicatorModel(
              title: 'معسكرات اكتشاف نهاية الأسبوع',
              description: 'تنسيق مع مدارس ونوادي محلية',
            ),
          ],
        ),
      ];
    default:
      return [
        ObjectActiveModel(
          id: 301,
          title: 'تحسين تجربة المشجع داخل الملعب',
          description: 'خدمات، إرشاد، وتجربة دخول وخروج',
          strategicAxisId: 3,
          kpIs: [
            IndicatorModel(
              title: 'مؤشر رضا الجماهير بعد المباريات',
              status: 'متقدم',
              percentage: '82',
            ),
            IndicatorModel(
              title: 'زمن انتظار شراء التذاكر في المنصات',
              status: 'متقدم',
              percentage: '64',
            ),
          ],
          initiatives: [
            IndicatorModel(
              title: 'مضيفون لكل بوابة في أيام المباريات',
              description: 'دعم فوري للمشجعين',
            ),
          ],
        ),
        ObjectActiveModel(
          id: 302,
          title: 'زيادة التفاعل الرقمي مع جمهور النادي',
          description: 'محتوى، بث، وتطبيقات',
          strategicAxisId: 3,
          kpIs: [
            IndicatorModel(
              title: 'معدل نمو متابعي الحسابات الرسمية',
              status: 'متأخر',
              percentage: '41',
            ),
          ],
          initiatives: [
            IndicatorModel(
              title: 'حملة موسمية للعضويات الرقمية',
              description: 'مزايا حصرية للمشتركين',
            ),
          ],
        ),
      ];
  }
}

/// Prefers API-linked objectives; falls back to football-club demo per selected axis index.
List<ObjectActiveModel> resolveStrategicAxisObjectives(
  VisionDataModel vision,
  int axisIndex,
) {
  final fromApi = objectivesForStrategicAxisIndex(vision, axisIndex);
  if (fromApi.isNotEmpty) return fromApi;
  return footballClubStrategicAxisDemoObjectives(axisIndex);
}
