import 'package:pms_system/core/utility/pms_exports.dart';

class PmsHomeView extends StatelessWidget {
  const PmsHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Stack(
          children: [MainHeader(), PmsHomeBody()],
        ),
      ),
    );
  }
}

class PmsHomeBody extends StatelessWidget {
  const PmsHomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 150, left: 16.w, right: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.h),
          Center(
            child: Text(
              'PMS Home',
              style: context.textTheme.headlineMedium,
            ),
          ),
        ],
      ),
    );
  }
}
