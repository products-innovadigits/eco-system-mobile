import 'package:flutter/material.dart';
import 'package:eco_system/utility/extintions.dart';
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
        fontSize: 11,
      ),
      unselectedLabelStyle: TextStyle(
        color: context.theme.primaryColorDark,
        fontSize: 11,
      ),
      unselectedItemColor: context.theme.primaryColorDark,
      selectedItemColor: context.theme.primaryColor,
      items: [
        BottomNavigationBarItem(
          icon: Images(
            image: 'assets/svgs/cube.svg',
            color: _selectedColor(0),
          ),
          label: "الرئيسية",
        ),
        BottomNavigationBarItem(
          icon: Images(
            image: 'assets/svgs/invoices.svg',
            color: _selectedColor(1),
          ),
          label: "المشاريع",
        ),
        BottomNavigationBarItem(
          icon: Images(
            image: 'assets/svgs/buildings.svg',
            color: _selectedColor(2),
          ),
          label: "المفضلة",
        ),
        BottomNavigationBarItem(
          icon: Images(
            image: 'assets/svgs/profile-circle.svg',
            color: _selectedColor(3),
          ),
          label: "الحساب",
        ),
      ],
    );
  }
}
