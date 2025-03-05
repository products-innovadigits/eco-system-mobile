import 'package:eco_system/navigation/custom_navigation.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:flutter/material.dart';
import '../../../helpers/styles.dart';
import '../../../navigation/routes.dart';
import '../../project_details/model/project_details_model.dart';
import 'project_card_content.dart';

class ProjectCard extends StatelessWidget {
  const ProjectCard({super.key, required this.project});
  final ProjectDetailsModel project;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () =>
          CustomNavigator.push(Routes.PROJECT_DETAILS, arguments: project.id),
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
        child: ProjectCardContent(project: project),
      ),
    );
  }
}
