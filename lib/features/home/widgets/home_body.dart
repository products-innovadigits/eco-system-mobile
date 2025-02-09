import 'package:eco_system/utility/extintions.dart';
import 'package:flutter/material.dart';

import '../../goal_progress/view/progress_goal_section.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          SizedBox(height: context.h * 0.15),
          ProgressGoalSection(),
        ],
      ),
    );
  }
}
