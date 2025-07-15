import 'package:core_package/core/utility/export.dart';
import 'package:strategy_package/bsc/model/objectives_model.dart';

class BscBloc extends Bloc<AppEvent, AppState> {
  BscBloc() : super(Start()) {
    on<Select>(_onChangeSelectedAxes);
    on<Expand>(_onExpandObjective);
    on<ToggleKpis>(_onToggleKpis);
    on<ToggleInitiatives>(_onToggleInitiatives);
  }

  int selectedAxes = 0;
  final List<String> axes = [
    'تقويم الانظمة الحكومية',
    'تحسين نمط الحياة',
    'تحقيق الاستدامة',
  ];
  final List<String> results = [
    'نظام حكومي متكامل متوائم بكافة قطاعاته يحقق الأثر الاقتصادي والاجتماعي بأعلى المعايير والتطلعات',
    'تحسين جودة الحياة للمواطنين والمقيمين',
    'تحقيق الاستدامة في جميع القطاعات',
  ];
  final List<String> perspectives = [
    'المنظور المالي',
    'عمليات داخليه',
    'المستفيدين',
    'التعلم والنمو',
  ];
  final List<String> values = [
    'الاحترافية',
    'الابداع والابتكار',
    'الاتقان',
    'التحفيز',
  ];
  final List<ObjectiveDataModel> objectives = [
    ObjectiveDataModel(
      title: 'تحقيق التميز في تقديم الخدمات الحكومية',
      kpis: [
        IndicatorModel(indicatorTitle: 'معدل رضا المستفيدين'),
        IndicatorModel(indicatorTitle: 'نسبة التحول الرقمي للخدمات'),
      ],
      initiatives: [
        IndicatorModel(indicatorTitle: 'تطوير منصة الخدمات الحكومية'),
        IndicatorModel(indicatorTitle: 'تحسين تجربة المستخدم'),
      ],
    ),
    ObjectiveDataModel(
      title: 'تعزيز الشفافية والمساءلة',
      kpis: [
        IndicatorModel(indicatorTitle: 'نسبة الشفافية في التقارير المالية'),
        IndicatorModel(indicatorTitle: 'عدد الشكاوى المعالجة'),
      ],
      initiatives: [
        IndicatorModel(indicatorTitle: 'تطوير نظام الشكاوى والمقترحات'),
        IndicatorModel(indicatorTitle: 'تعزيز التواصل مع المجتمع'),
      ],
    ),
  ];

  int expandedObjectiveId = -1;
  bool isKpisExpanded = false;
  bool isInitiativesExpanded = false;

  void _onChangeSelectedAxes(AppEvent event, Emitter<AppState> emit) {
    int selectedAxesId = event.arguments as int;
    selectedAxes = selectedAxesId;
    emit(Done());
  }

  void _onExpandObjective(Expand event, Emitter<AppState> emit) {
    final objId = event.arguments as int;
    if (expandedObjectiveId == objId) {
      expandedObjectiveId = -1;
    } else {
      expandedObjectiveId = objId;
      isKpisExpanded = false;
      isInitiativesExpanded = false;
    }
    emit(Done());
  }

  void _onToggleKpis(ToggleKpis event, Emitter<AppState> emit) {
    if (expandedObjectiveId == event.arguments as int) {
      isKpisExpanded = !isKpisExpanded;
      emit(Done());
    }
  }

  void _onToggleInitiatives(ToggleInitiatives event, Emitter<AppState> emit) {
    if (expandedObjectiveId == event.arguments as int) {
      isInitiativesExpanded = !isInitiativesExpanded;
      emit(Done());
    }
  }
}
