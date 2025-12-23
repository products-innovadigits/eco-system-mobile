import '../../shared/pms_exports.dart';

class PmsHomeBody extends StatelessWidget {
  const PmsHomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PmsBloc(),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            spacing: 16.h,
            children: [
              const SizedBox(height: 80),
              ProjectManagementSection(isPmsHome: true),
              const LatestRequestsSection(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
