import 'package:eco_system/core/app_event.dart';
import 'package:eco_system/core/app_state.dart';
import 'package:eco_system/core/app_strings/locale_keys.dart';
import 'package:eco_system/core/assets.gen.dart';
import 'package:eco_system/features/ats/profile/bloc/profile_bloc.dart';
import 'package:eco_system/features/ats/profile/view/widgets/manager_review_card_widget.dart';
import 'package:eco_system/helpers/styles.dart';
import 'package:eco_system/helpers/text_styles.dart';
import 'package:eco_system/helpers/translation/all_translation.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:eco_system/widgets/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ManagersReviewsListSection extends StatelessWidget {
  const ManagersReviewsListSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300.h,
      child: ListView.separated(
          itemBuilder: (context, index) => ManagerReviewCardWidget(
                isExpanded: context.read<ProfileBloc>().reviewExpandedIndex == index,
                onExpand: () => context.read<ProfileBloc>().add(ToggleExpand(arguments: index)),
              ),
          separatorBuilder: (context, index) => 16.sh,
          itemCount: 10),
    );
  }
}
