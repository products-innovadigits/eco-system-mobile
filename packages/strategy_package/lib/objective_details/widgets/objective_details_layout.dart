import 'package:core_package/core/utility/export.dart';

class ObjectiveDetailsLayout extends StatefulWidget {
  const ObjectiveDetailsLayout(
      {super.key, required this.child, required this.title, this.subTitle});
  final Widget child;
  final String title;
  final String? subTitle;

  @override
  State<ObjectiveDetailsLayout> createState() => _ObjectiveDetailsLayoutState();
}

class _ObjectiveDetailsLayoutState extends State<ObjectiveDetailsLayout> {
  bool isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
      decoration: BoxDecoration(
          color: Styles.WHITE_COLOR,
          border: Border.all(color: context.color.outline),
          borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => setState(() => isExpanded = !isExpanded),
            child: Row(
              children: [
                Expanded(
                  child: RichText(
                      text: TextSpan(
                          text: widget.title,
                          style: AppTextStyles.w600
                              .copyWith(fontSize: 14, color: Styles.HEADER),
                          children: [
                        if (widget.subTitle != null)
                          TextSpan(
                            text: "  ${widget.subTitle}",
                            style: AppTextStyles.w400.copyWith(
                                fontSize: 12, color: Styles.PRIMARY_COLOR),
                          )
                      ])),
                ),
                SizedBox(height: 12.h),
                AnimatedRotation(
                  duration: const Duration(milliseconds: 450),
                  turns: isExpanded ? 0.5 : 0,
                  child: customImageIconSVG(
                      imageName: 'up', color: Styles.PRIMARY_COLOR),
                ),
              ],
            ),
          ),
          AnimatedCrossFade(
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 400),
            firstChild: SizedBox(height: 0, width: MediaQueryHelper.width),
            secondChild: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: Divider(color: context.color.outline),
                ),
                widget.child
              ],
            ),
          ),
        ],
      ),
    );
  }
}
