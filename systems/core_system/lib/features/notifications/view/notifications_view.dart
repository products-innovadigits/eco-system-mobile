import 'package:core_system/core/utility/export.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(allTranslations.text(LocaleKeys.notifications)),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Text(
            allTranslations.text(LocaleKeys.notifications),
            textAlign: TextAlign.center,
            style: context.textTheme.bodyLarge,
          ),
        ),
      ),
    );
  }
}
