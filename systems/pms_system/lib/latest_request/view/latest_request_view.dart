import 'package:pms_system/latest_request/bloc/latest_request_bloc.dart';
import 'package:pms_system/shared/pms_exports.dart';

class LatestRequestView extends StatelessWidget {
  const LatestRequestView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LatestRequestBloc(),
      child: Scaffold(
        appBar: AppBar(title: Text('Latest Request')),
        body: Center(child: Text('Latest Request View - Placeholder')),
      ),
    );
  }
}
