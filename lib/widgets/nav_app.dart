import 'package:eco_system/core/app_strings/locale_keys.dart';
import 'package:eco_system/core/assets.gen.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:eco_system/widgets/nav_app_item.dart';
import 'package:flutter/material.dart';

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
          fontSize: 11,
          fontWeight: FontWeight.w600),
      unselectedLabelStyle: TextStyle(
        color: context.theme.primaryColorDark,
        fontSize: 11,
      ),
      unselectedItemColor: context.theme.primaryColorDark,
      selectedItemColor: context.theme.primaryColor,
      items: [
        BottomNavigationBarItem(
          icon: NavAppItem(
              title: LocaleKeys.home,
              isSelected: widget.index == 0,
              icon: Assets.svgs.home.path,
              activeIcon: Assets.svgs.homeActive.path,
              color: _selectedColor(0)),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: NavAppItem(
              title: LocaleKeys.reports,
              isSelected: widget.index == 1,
              icon: Assets.svgs.reports.path,
              activeIcon: Assets.svgs.reports.path,
              color: _selectedColor(1)),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: NavAppItem(
              title: LocaleKeys.notifications,
              isSelected: widget.index == 2,
              icon: Assets.svgs.notification.path,
              activeIcon: Assets.svgs.notification.path,
              color: _selectedColor(2)),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: NavAppItem(
              title: LocaleKeys.menu,
              isSelected: widget.index == 3,
              icon: Assets.svgs.more.path,
              activeIcon: Assets.svgs.more.path,
              color: _selectedColor(3)),
          label: '',
        ),
      ],
    );
  }
}
