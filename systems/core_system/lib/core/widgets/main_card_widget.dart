import 'package:core_system/core/utility/export.dart';

class MainCardWidget extends StatelessWidget {
  final Widget child;
  final String title;
  final double? height;
  final VoidCallback? onViewMoreTap;

  const MainCardWidget({
    super.key,
    required this.child,
    required this.title,
    this.onViewMoreTap, this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: context.w,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: context.color.surfaceContainer,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.color.outline),
      ),
      child: Column(
        children: [
          SectionTitle(
            title: title,
            withView: onViewMoreTap != null,
            onViewTap: onViewMoreTap,
          ),
          Divider(color: context.color.outline),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
