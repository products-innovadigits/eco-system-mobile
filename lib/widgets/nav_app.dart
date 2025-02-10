import 'package:eco_system/helpers/translation/all_translation.dart';
import 'package:flutter/material.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:eco_system/widgets/images.dart';

class NavApp extends StatefulWidget {
  const NavApp({
    super.key,
    required this.index,
    this.onSelect,
  });
  final int index;
  final Function(int)? onSelect;

  @override
  State<NavApp> createState() => _NavAppState();
}

class _NavAppState extends State<NavApp> {
  Color _selectedColor(int index) => widget.index == index
      ? context.theme.primaryColor
      : context.theme.primaryColorDark;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      iconSize: 35,
      onTap: widget.onSelect,
      type: BottomNavigationBarType.fixed,
      currentIndex: widget.index,
      selectedLabelStyle: TextStyle(
          color: context.theme.primaryColor,
          fontSize: 13,
          fontWeight: FontWeight.w600),
      unselectedLabelStyle: TextStyle(
        color: context.theme.primaryColorDark,
        fontSize: 11,
      ),
      unselectedItemColor: context.theme.primaryColorDark,
      selectedItemColor: context.theme.primaryColor,
      items: [
        BottomNavigationBarItem(
          icon: Images(
            image: 'assets/svgs/home.svg',
            color: _selectedColor(0),
          ),
          label: allTranslations.text("home"),
        ),
        BottomNavigationBarItem(
          icon: Images(
            image: 'assets/svgs/reports.svg',
            color: _selectedColor(1),
          ),
          label: allTranslations.text("reports"),
        ),
        BottomNavigationBarItem(
          icon: Images(
            image: 'assets/svgs/notification.svg',
            color: _selectedColor(2),
          ),
          label: allTranslations.text("notifications"),
        ),
        BottomNavigationBarItem(
          icon: Images(
            image: 'assets/svgs/more.svg',
            color: _selectedColor(3),
          ),
          label: allTranslations.text("menu"),
        ),
      ],
    );
  }
}
