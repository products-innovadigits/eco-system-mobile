import '../utility/export.dart';

class ShimmerCardsList extends StatelessWidget {
  final int? itemCount;
  final double? cardHeight;

  const ShimmerCardsList({super.key, this.itemCount, this.cardHeight});

  @override
  Widget build(BuildContext context) {
    return ListAnimator(
      customPadding: EdgeInsets.symmetric(horizontal: 16.w),
      data: List.generate(
        itemCount ?? 10,
        (index) => Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: CustomShimmerContainer(height: cardHeight ?? 125.h),
        ),
      ),
    );
  }
}
