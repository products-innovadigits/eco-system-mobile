import 'package:pms_system/core/utility/pms_exports.dart';

class CycleRevieweesShimmer extends StatelessWidget {
  const CycleRevieweesShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        children: List.generate(
          6,
          (index) => Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: const _RevieweeCardShimmer(),
          ),
        ),
      ),
    );
  }
}

class _RevieweeCardShimmer extends StatelessWidget {
  const _RevieweeCardShimmer();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: context.color.surfaceContainer,
        border: Border.all(color: context.color.outline),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CustomShimmerContainer(
            height: 40.w,
            width: 40.w,
            borderRadius: 20,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomShimmerContainer(
                  height: 14.h,
                  width: context.w * 0.35,
                  borderRadius: 6,
                ),
                SizedBox(height: 6.h),
                CustomShimmerContainer(
                  height: 10.h,
                  width: context.w * 0.25,
                  borderRadius: 6,
                ),
              ],
            ),
          ),
          CustomShimmerContainer(
            height: 12.h,
            width: 30.w,
            borderRadius: 6,
          ),
          SizedBox(width: 8.w),
          CustomShimmerContainer(
            height: 24.h,
            width: 40.w,
            borderRadius: 12,
          ),
          SizedBox(width: 8.w),
          CustomShimmerContainer(
            height: 18.w,
            width: 18.w,
            borderRadius: 9,
          ),
        ],
      ),
    );
  }
}
