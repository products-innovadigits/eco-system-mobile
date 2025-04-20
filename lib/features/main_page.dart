import 'package:eco_system/widgets/nav_app.dart';
import 'package:flutter/material.dart';

import 'home/view/home_view.dart';

class MainPage extends StatefulWidget {
  final int index;

  const MainPage({super.key, this.index = 0});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with WidgetsBindingObserver {
  int _index = 0;

  @override
  void initState() {
    _index = widget.index;
    super.initState();
  }

  Widget fregmant(int index) {
    switch (index) {
      case 0:
        return HomeView();
      case 1:
        return SizedBox();
      case 2:
        return SizedBox();
      case 3:
        return SizedBox();
      default:
        return SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: fregmant(_index),
      bottomNavigationBar: NavApp(
        index: _index,
        onSelect: (p0) {
          _index = p0;
          setState(() {});
        },
      ),
    );
  }
}
