
import 'package:pms_package/shared/pms_exports.dart';

class ProjectDetailsView extends StatelessWidget {
  const ProjectDetailsView({super.key, required this.id});
  final int id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "", withBottomBorder: false),
      body: SafeArea(
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) =>
                  ProjectDetailsBloc()..add(Click(arguments: id)),
            ),
          ],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: ListAnimator(
                data: [
                  ///Objective Details
                  ProjectDetailsBody(),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
