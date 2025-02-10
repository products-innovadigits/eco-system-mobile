import 'package:eco_system/utility/extensions.dart';
import 'package:flutter/material.dart';
import '../../../helpers/styles.dart';
import '../model/objectives_model.dart';

class ObjectiveCard extends StatelessWidget {
  const ObjectiveCard({super.key, required this.objective});
  final ObjectiveModel objective;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
          color: Styles.WHITE_COLOR,
          border: Border.all(color: Styles.LIGHT_GREY_BORDER),
          borderRadius: BorderRadius.circular(12.w)),
      child: Column(
        children: [],
      ),
    );
  }
}
