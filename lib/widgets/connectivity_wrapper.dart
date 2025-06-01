import 'package:eco_system/utility/export.dart';
import 'package:eco_system/widgets/connectivity_widget.dart';

class ConnectivityWrapper extends StatefulWidget {
  final Widget child;

  const ConnectivityWrapper({
    super.key,
    required this.child,
  });

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

              return Stack(
                children: [
                  widget.child,
                  if (!isConnected)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: const ConnectivityWidget(),
                    ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
