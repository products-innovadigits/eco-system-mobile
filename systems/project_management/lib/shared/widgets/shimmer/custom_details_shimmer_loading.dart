import 'package:project_management/core/utility/project_management_exports.dart';

class CustomDetailsShimmerLoading extends StatelessWidget {
  const CustomDetailsShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomShimmerContainer(height: context.h * 0.2, width: context.w),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Divider(color: context.color.outline, thickness: 1.0),
            ),
            CustomShimmerContainer(height: context.h * 0.3, width: context.w),
            SizedBox(height: 8.h),
            CustomShimmerContainer(height: context.h * 0.3, width: context.w),
          ],
        ),
      ),
    );
  }
}
