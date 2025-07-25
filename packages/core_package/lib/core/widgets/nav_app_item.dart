import 'package:core_package/core/utility/export.dart';

class NavAppItem extends StatelessWidget {
  final String title;
  final bool isSelected;
  final Color color;
  final String icon;
  final String activeIcon;

  const NavAppItem(
      {super.key,
      required this.title,
      required this.isSelected,
      required this.icon,
      required this.color,
      required this.activeIcon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20.h,
        ),
        Images(
          image: isSelected ? activeIcon : icon,
          color: color,
        ),
        SizedBox(height: 2.h),
        Text(
          allTranslations.text(title),
          style: TextStyle(
            color: color,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 10.h),
        isSelected
            ? Images(
                image: Assets.svgs.navbarArrow.path,
                color: context.theme.primaryColor,
              )
            : SizedBox.shrink(),
      ],
    );
  }
}
