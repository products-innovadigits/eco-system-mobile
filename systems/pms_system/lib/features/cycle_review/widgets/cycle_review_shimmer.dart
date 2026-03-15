import 'package:pms_system/core/utility/pms_exports.dart';

class CycleReviewShimmer extends StatelessWidget {
  const CycleReviewShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16.h),
          // Header shimmer (icon + title + badge)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomShimmerContainer(
                height: 42.w,
                width: 42.w,
                borderRadius: 10,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomShimmerContainer(
                      height: 18.h,
                      width: context.w * 0.6,
                      borderRadius: 6,
                    ),
                    SizedBox(height: 8.h),
                    CustomShimmerContainer(
                      height: 12.h,
                      width: context.w * 0.4,
                      borderRadius: 6,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          // Overall progress section
          CustomShimmerContainer(
            height: 80.h,
            width: double.infinity,
            borderRadius: 12,
          ),
          SizedBox(height: 24.h),
          // Reviewers section
          CustomShimmerContainer(height: 20.h, width: 100.w, borderRadius: 6),
          SizedBox(height: 12.h),
          CustomShimmerContainer(
            height: 70.h,
            width: double.infinity,
            borderRadius: 12,
          ),
          SizedBox(height: 10.h),
          CustomShimmerContainer(
            height: 70.h,
            width: double.infinity,
            borderRadius: 12,
          ),
          SizedBox(height: 24.h),
          // Cycle overview section
          CustomShimmerContainer(height: 20.h, width: 120.w, borderRadius: 6),
          SizedBox(height: 14.h),
          Row(
            children: [
              Expanded(
                child: CustomShimmerContainer(
                  height: 100.h,
                  borderRadius: 12,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: CustomShimmerContainer(
                  height: 100.h,
                  borderRadius: 12,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          CustomShimmerContainer(
            height: 50.h,
            width: double.infinity,
            borderRadius: 12,
          ),
          SizedBox(height: 4.h),
          CustomShimmerContainer(
            height: 50.h,
            width: double.infinity,
            borderRadius: 12,
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}
