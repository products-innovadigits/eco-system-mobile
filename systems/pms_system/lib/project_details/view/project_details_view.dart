import 'package:pms_system/shared/pms_exports.dart';

class ProjectDetailsView extends StatelessWidget {
  const ProjectDetailsView({super.key, required this.id});

  final int id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "", withBottomBorder: false),
      body: SafeArea(
        child: BlocProvider(
          create: (context) => ProjectDetailsBloc()..add(Click(arguments: id)),
          child: ProjectDetailsBody(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: context.color.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        child: Images(
          image: Assets.svgs.chartReport.path,
          width: 20.w,
          height: 20.h,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}
