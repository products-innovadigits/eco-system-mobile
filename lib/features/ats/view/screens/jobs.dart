import 'package:eco_system/core/app_strings/locale_keys.dart';
import 'package:eco_system/features/ats/bloc/jobs_bloc.dart';
import 'package:eco_system/features/ats/view/sections/jobs/jobs_list_section.dart';
import 'package:eco_system/helpers/translation/all_translation.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:eco_system/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Jobs extends StatelessWidget {
  const Jobs({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => JobsBloc(),
      child: Scaffold(
        appBar: CustomAppBar(
            title: allTranslations.text('jobs'),
            withSearch: true,
            searchHintText: allTranslations.text(LocaleKeys.searching_for_job)),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: JobsListSection(hasStatus: true),
        ),
      ),
    );
  }
}
