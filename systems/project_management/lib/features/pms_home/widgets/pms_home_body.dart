import 'package:project_management/core/utility/pms_exports.dart';

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
