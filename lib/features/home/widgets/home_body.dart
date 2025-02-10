import 'package:eco_system/utility/extensions.dart';
import 'package:flutter/material.dart';
import '../../objective_active/view/objective_active_section.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          SizedBox(height: context.h * 0.15),
          ObjectiveActiveSection(),
        ],
      ),
    );
  }
}
