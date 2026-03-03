import 'dart:developer';

import 'package:core_system/core/utility/export.dart';
import 'package:core_system/core/widgets/connectivity_widget.dart';

class ConnectivityWrapper extends StatefulWidget {
  final Widget child;

  static const _enableProxy =
      bool.fromEnvironment('ENABLE_PROXY', defaultValue: false);

  const ConnectivityWrapper({super.key, required this.child});

  @override
  State<ConnectivityWrapper> createState() => _ConnectivityWrapperState();
}

class _ConnectivityWrapperState extends State<ConnectivityWrapper> {
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
              log('ConnectivityWrapper - isConnected: $isConnected');
              return Stack(
                children: [
                  widget.child,
                  if (!ConnectivityWrapper._enableProxy && !isConnected)
                    const ConnectivityWidget(),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
