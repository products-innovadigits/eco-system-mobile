import 'package:eco_system/services/connectivity_service.dart';
import 'package:eco_system/utility/export.dart';

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
          child: StreamBuilder<bool?>(
            stream: mainAppBloc.connectivityStream,
            builder: (context, connectivitySnapshot) {
              final isConnected = connectivitySnapshot.data ?? true;

              if (isConnected) return const SizedBox.shrink();

              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                height: isConnected ? 0 : 40,
                color: Styles.ERROR_COLOR,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.wifi_off_rounded,
                        color: Styles.WHITE_COLOR,
                        size: 20,
                      ),
                      8.sw,
                      Text(
                        allTranslations.text(LocaleKeys.no_internet_connection),
                        style: AppTextStyles.w500.copyWith(
                          color: Styles.WHITE_COLOR,
                          fontSize: 14,
                        ),
                      ),
                      if (!isConnected) ...[
                        8.sw,
                        IconButton(
                          icon: Icon(
                            Icons.refresh_rounded,
                            color: Styles.WHITE_COLOR,
                            size: 20,
                          ),
                          onPressed: () async {
                            final connectivityService = ConnectivityService();
                            await connectivityService.checkConnection();
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
