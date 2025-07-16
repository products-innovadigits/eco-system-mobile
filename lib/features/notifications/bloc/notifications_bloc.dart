import 'package:core_package/core/utility/export.dart';
import 'package:eco_system/features/notifications/model/notification_model.dart';

class NotificationsBloc extends Bloc<AppEvent, AppState> {
  NotificationsBloc() : super(Start()) {}

  final List<NotificationData> notifications = [
    NotificationData(
      id: '1',
      title: 'تقدم المشروع ”المجلس الصحي“',
      body:
          'تم الانتهاء من 75% من المشروع، هناك معوقات محتملة تحتاج إلى انتباهك',
      date: 'الان',
      type: 'مراجعة حالة المشروع',
    ),
    NotificationData(
      id: '2',
      title: 'تحديثات على مشروع ”المدينة الذكية“',
      body: 'تم إضافة ميزات جديدة للمشروع، يرجى مراجعة التحديثات في التطبيق',
      date: 'الان',
    ),
    NotificationData(
      id: '3',
      title: 'تذكير بمشروع ”الطاقة المتجددة“',
      body: 'لا تنسَ مراجعة التقدم في مشروع الطاقة المتجددة قبل نهاية الشهر',
      date: 'الان',
    ),
    NotificationData(
      id: '4',
      title: 'دعوة لحضور اجتماع ”المشاريع المستقبلية“',
      body: 'تم تحديد موعد الاجتماع يوم الخميس المقبل، يرجى تأكيد الحضور',
      date: 'الان',
    ),
    NotificationData(
      id: '5',
      title: 'تحديثات على مشروع ”النقل الذكي“',
      body: 'تم إضافة ميزات جديدة للمشروع، يرجى مراجعة التحديثات في التطبيق',
      date: 'الان',
      type: 'مراجعة حالة المشروع',
    ),
    NotificationData(
      id: '6',
      title: 'تذكير بمشروع ”البيئة المستدامة“',
      body: 'لا تنسَ مراجعة التقدم في مشروع البيئة المستدامة قبل نهاية الشهر',
      date: 'الان',
    ),
  ];
}
