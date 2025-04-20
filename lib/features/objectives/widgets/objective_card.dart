import 'package:eco_system/navigation/custom_navigation.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:flutter/material.dart';

import '../../../helpers/styles.dart';
import '../../../navigation/routes.dart';
import '../../objective_details/model/objective_details_model.dart';
import 'objective_card_content.dart';

class ObjectiveCard extends StatelessWidget {
  const ObjectiveCard({super.key, required this.objective});
  final ObjectiveDetailsModel objective;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => CustomNavigator.push(Routes.OBJECTIVE_DETAILS,
          arguments: objective.id),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
            color: Styles.WHITE_COLOR,
            border: Border.all(color: Styles.LIGHT_GREY_BORDER),
            borderRadius: BorderRadius.circular(12.w)),
        child: ObjectiveCardContent(objective: objective),
      ),
    );
  }
}
