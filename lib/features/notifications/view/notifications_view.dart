import 'package:core_package/core/utility/export.dart';
import 'package:eco_system/features/notifications/bloc/notifications_bloc.dart';
import 'package:eco_system/features/notifications/widgets/notification_card_widget.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotificationsBloc(),
      child: Scaffold(
        appBar: CustomAppBar(
          title: allTranslations.text(LocaleKeys.notifications),
          withBackBtn: false,
        ),
        body: BlocBuilder<NotificationsBloc, AppState>(
          builder: (context, state) {
            final bloc = context.read<NotificationsBloc>();
            final notificationsList = bloc.notifications;
            return ListAnimator(
              data: List.generate(
                notificationsList.length,
                (index) => NotificationCardWidget(
                  notificationData: notificationsList[index],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
