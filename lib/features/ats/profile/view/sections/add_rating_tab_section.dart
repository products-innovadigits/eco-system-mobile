import 'package:eco_system/core/app_event.dart';
import 'package:eco_system/core/app_strings/locale_keys.dart';
import 'package:eco_system/features/ats/profile/bloc/profile_bloc.dart';
import 'package:eco_system/features/ats/profile/view/sections/custom_rating_section.dart';
import 'package:eco_system/helpers/translation/all_translation.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddRatingTabSection extends StatelessWidget {
  const AddRatingTabSection({super.key});

  @override
  Widget build(BuildContext context) {
    final profileBloc = context.read<ProfileBloc>();
    return Column(
      children: [
        CustomRatingSection(
          title: allTranslations.text(LocaleKeys.technical_skills),
          commentController: profileBloc.techSkillsController,
          selectedRating: profileBloc.selectedTechSkillsRate,
          onCommentAdded: (comment) {
            profileBloc.techSkillsController.text = comment;
          },
          onRatingSelected: (rate) {
            profileBloc.add(onTechSkillRate(arguments: rate));
          },
        ),
        16.sh,
        CustomRatingSection(
          title: allTranslations.text(LocaleKeys.knowledge),
          commentController: profileBloc.knowledgeController,
          selectedRating: profileBloc.selectedKnowledgeRate,
          onCommentAdded: (comment) {
            profileBloc.knowledgeController.text = comment;
          },
          onRatingSelected: (rate) {
            profileBloc.add(onKnowledgeRate(arguments: rate));
          },
        ),
        16.sh,
        CustomRatingSection(
          title: allTranslations.text(LocaleKeys.communications),
          commentController: profileBloc.communicationController,
          selectedRating: profileBloc.selectedCommunicationRate,
          onCommentAdded: (comment) {
            profileBloc.communicationController.text = comment;
          },
          onRatingSelected: (rate) {
            profileBloc.add(onCommunicationRate(arguments: rate));
          },
        ),
        16.sh,
      ],
    );
  }
}
