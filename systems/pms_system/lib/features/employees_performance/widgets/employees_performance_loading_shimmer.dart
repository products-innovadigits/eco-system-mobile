import 'package:pms_system/core/utility/pms_exports.dart';

class EmployeesPerformanceLoadingShimmer extends StatelessWidget {
  const EmployeesPerformanceLoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _PodiumShimmer(),
        SizedBox(height: 24.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: CustomShimmerContainer(
            height: 18.h,
            width: 100.w,
            borderRadius: 6,
            padding: EdgeInsets.zero,
          ),
        ),
        SizedBox(height: 12.h),
        ...List.generate(5, (_) => _TopEmployeeRowShimmer()),
      ],
    );
  }
}

class _PodiumShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: _PodiumColumnShimmer(avatarSize: 70, podiumHeight: 80),
          ),
          Expanded(
            child: _PodiumColumnShimmer(avatarSize: 90, podiumHeight: 120),
          ),
          Expanded(
            child: _PodiumColumnShimmer(avatarSize: 70, podiumHeight: 60),
          ),
        ],
      ),
    );
  }
}

class _PodiumColumnShimmer extends StatelessWidget {
  final double avatarSize;
  final double podiumHeight;

  const _PodiumColumnShimmer({
    required this.avatarSize,
    required this.podiumHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomShimmerCircleImage(radius: avatarSize),
        SizedBox(height: 14.h),
        CustomShimmerContainer(
          height: 12.h,
          width: 72.w,
          borderRadius: 4,
          padding: EdgeInsets.zero,
        ),
        SizedBox(height: 4.h),
        CustomShimmerContainer(
          height: 10.h,
          width: 52.w,
          borderRadius: 4,
          padding: EdgeInsets.zero,
        ),
        SizedBox(height: 8.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: CustomShimmerContainer(
            height: podiumHeight.h,
            width: double.infinity,
            borderRadius: 12,
            padding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }
}

class _TopEmployeeRowShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.h),
      child: Container(
        padding: EdgeInsetsDirectional.only(
          start: 16.w,
          top: 12.h,
          bottom: 12.h,
          end: 12.w,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: LightColor.border),
        ),
        child: Row(
          children: [
            CustomShimmerContainer(
              height: 22.h,
              width: 22.w,
              borderRadius: 6,
              padding: EdgeInsets.zero,
            ),
            SizedBox(width: 10.w),
            CustomShimmerCircleImage(radius: 50),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomShimmerContainer(
                    height: 14.h,
                    width: context.w * 0.45,
                    borderRadius: 4,
                    padding: EdgeInsets.zero,
                  ),
                  SizedBox(height: 6.h),
                  CustomShimmerContainer(
                    height: 11.h,
                    width: context.w * 0.32,
                    borderRadius: 4,
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            CustomShimmerContainer(
              height: 32.h,
              width: 56.w,
              borderRadius: 8,
              padding: EdgeInsets.zero,
            ),
            SizedBox(width: 8.w),
            CustomShimmerContainer(
              height: 32.h,
              width: 72.w,
              borderRadius: 8,
              padding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }
}
