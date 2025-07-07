
import 'package:core_package/core/utility/export.dart';

class LoadingShimmerList extends StatelessWidget {
  final int? itemCount;
  const LoadingShimmerList({super.key, this.itemCount});

  @override
  Widget build(BuildContext context) {
    return ListAnimator(
      data: List.generate(
         itemCount ?? 10,
          (index) => Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: CustomShimmerContainer(
                  height: 125.h,
                  width: context.w,
                ),
              )),
    );
  }
}
