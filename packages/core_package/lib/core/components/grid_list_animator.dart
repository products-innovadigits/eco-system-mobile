import 'package:core_package/core/utility/export.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class GridListAnimator extends StatelessWidget {
  final List<Widget>? data;
  final int? rowCount;
  final bool? neverScrollView;
  final double? aspectRatio;

  const GridListAnimator({
    super.key,
    this.data,
    this.rowCount,
    this.aspectRatio,
    this.neverScrollView = false,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: const EdgeInsets.only(top: 5),
      crossAxisCount: rowCount ?? 2,
      physics: neverScrollView!
          ? const NeverScrollableScrollPhysics()
          : const BouncingScrollPhysics(),
      shrinkWrap: true,
      addAutomaticKeepAlives: true,
      childAspectRatio: aspectRatio ?? 1.7,
      mainAxisSpacing: .25,
      crossAxisSpacing: .3,
      children: List.generate(
        data!.length,
        (int index) {
          return AnimationConfiguration.staggeredGrid(
            columnCount: rowCount ?? 2,
            position: index,
            duration: const Duration(milliseconds: 375),
            child: ScaleAnimation(
              child: FadeInAnimation(child: data![index]),
            ),
          );
        },
      ),
    );
  }
}
