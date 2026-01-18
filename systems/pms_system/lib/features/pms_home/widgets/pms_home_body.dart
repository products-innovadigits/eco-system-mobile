import 'package:pms_system/core/utility/pms_exports.dart';
import 'package:pms_system/features/pms_home/bloc/pms_cubit.dart';
import 'package:pms_system/features/projects_progress/view/project_management_section.dart';

class PmsHomeBody extends StatelessWidget {
  const PmsHomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PmsCubit(),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            spacing: 16.h,
            children: [
              SizedBox(height: 80.h),
              ProjectManagementSection(isPmsHome: true),
              const LatestRequestsSection(),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}
