import 'package:flutter/material.dart';

import '../widgets/home_body.dart';
import '../widgets/home_header.dart';

class HomeView extends StatelessWidget {
  final List<String> systems;
  const HomeView({super.key, required this.systems});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Stack(
          children: [
            HomeHeader(),
            HomeBody(systems: systems),
          ],
        ),
      ),
    );
  }
}
