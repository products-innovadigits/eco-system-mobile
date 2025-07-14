import 'package:core_package/core/utility/export.dart';

class BscBloc extends Bloc<AppEvent, AppState> {
  BscBloc() : super(Start()) {
    on<Select>(_onChangeSelectedAxes);
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

  void _onChangeSelectedAxes(AppEvent event, Emitter<AppState> emit) {
    int selectedAxesId = event.arguments as int;
    selectedAxes = selectedAxesId;
    emit(Done());
  }
}
