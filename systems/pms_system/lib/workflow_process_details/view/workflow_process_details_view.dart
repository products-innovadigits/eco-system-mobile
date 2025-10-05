import 'package:pms_system/shared/pms_exports.dart';
import 'package:pms_system/workflow_process_details/widgets/process_details_body.dart';

class WorkflowProcessDetailsView extends StatelessWidget {
  const WorkflowProcessDetailsView({super.key, required this.id});

  final int id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "اختبار الاختراق – WF-CSD-03",
        withBottomBorder: false,
        action: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: context.color.secondary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            children: [
              Text(
                'في تقدم',
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.color.secondary,
                  fontSize: FontSizes.f10,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: BlocProvider(
          create: (context) => WorkflowProcessDetailsBloc()..add(Click(arguments: id)),
          // create: (context) => WorkflowProcessDetailsBloc(),
          child: ProcessDetailsBody(),
        ),
      ),
    );
  }
}
