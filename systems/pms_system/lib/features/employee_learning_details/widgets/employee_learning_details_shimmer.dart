import 'package:pms_system/core/utility/pms_exports.dart';

class EmployeeLearningDetailsShimmer extends StatelessWidget {
  const EmployeeLearningDetailsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16.h),
          CustomShimmerContainer(
            height: 24.h,
            width: context.w * 0.45,
            borderRadius: 6,
          ),
          SizedBox(height: 20.h),
          CustomShimmerContainer(
            height: 18.h,
            width: context.w * 0.55,
            borderRadius: 6,
          ),
          SizedBox(height: 12.h),
          _buildCompetencyCardShimmer(context),
          _buildCompetencyCardShimmer(context),
          SizedBox(height: 24.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomShimmerContainer(
                height: 18.h,
                width: 120.w,
                borderRadius: 6,
              ),
              CustomShimmerContainer(
                height: 14.h,
                width: 60.w,
                borderRadius: 6,
              ),
            ],
          ),
          SizedBox(height: 12.h),
          _buildReviewCycleCardShimmer(context),
          _buildReviewCycleCardShimmer(context),
          _buildReviewCycleCardShimmer(context),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  Widget _buildCompetencyCardShimmer(BuildContext context) {
    return CustomShimmer(
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.w),
        ),
        child: Row(
          children: [
            Container(
              width: 44.w,
              height: 44.w,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 12.h,
                    width: 80.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Container(
                    height: 12.h,
                    width: 60.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  height: 14.h,
                  width: 70.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                SizedBox(height: 6.h),
                Container(
                  height: 12.h,
                  width: 50.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewCycleCardShimmer(BuildContext context) {
    return CustomShimmer(
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.w),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 16.h,
              width: context.w * 0.5,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            SizedBox(height: 8.h),
            Container(
              height: 12.h,
              width: context.w * 0.4,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            SizedBox(height: 24.h),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.w),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Container(
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.w),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
