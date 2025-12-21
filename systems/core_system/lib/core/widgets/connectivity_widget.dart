import 'package:core_system/core/utility/export.dart';

class ConnectivityWidget extends StatelessWidget {
  const ConnectivityWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: mainAppBloc.langStream,
      builder: (context, langSnapshot) {
        final isRTL = langSnapshot.data == 'ar';

        return Directionality(
          textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: context.color.surface,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Images(image: Assets.svgs.error.path),
                        16.sh,
                        Text(
                          allTranslations.text(
                            LocaleKeys.no_internet_connection,
                          ),
                          style: context.textTheme.headlineSmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
