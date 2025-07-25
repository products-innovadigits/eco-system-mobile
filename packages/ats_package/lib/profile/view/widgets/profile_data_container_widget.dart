import 'package:core_package/core/helpers/font_sizes.dart';
import 'package:core_package/core/utility/export.dart';

class ProfileDataContainerWidget extends StatelessWidget {
  final String title;
  final String icon;
  final VoidCallback onTap;

  const ProfileDataContainerWidget(
      {super.key, required this.title, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
        decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: context.color.surfaceContainer),
            borderRadius: BorderRadius.circular(48)),
        child: Row(
          children: [
            Images(image: icon , color: context.color.onPrimary),
            6.sw,
            Text(
              title,
              textDirection: TextDirection.ltr,
              style: context.textTheme.labelSmall?.copyWith(color: context.color.onPrimary , fontSize: FontSizes.f10),
            ),
          ],
        ),
      ),
    );
  }
}
