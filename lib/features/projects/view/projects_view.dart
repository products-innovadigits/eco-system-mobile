import 'package:eco_system/helpers/translation/all_translation.dart';
import 'package:eco_system/model/search_engine.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../components/animated_widget.dart';
import '../../../components/custom_loading.dart';
import '../../../components/empty_container.dart';
import '../../../components/shimmer/custom_shimmer.dart';
import '../../../core/app_event.dart';
import '../../../core/app_state.dart';
import '../../../widgets/custom_app_bar.dart';
import '../bloc/projects_bloc.dart';
import '../widgets/project_search_bar.dart';

class ProjectsView extends StatelessWidget {
  const ProjectsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: allTranslations.text("projects"),
      ),
      body: SafeArea(
          child: BlocProvider(
        create: (context) =>
            ProjectsBloc()..add(Click(arguments: SearchEngine())),
        child: BlocBuilder<ProjectsBloc, AppState>(
          builder: (context, state) {
            return Column(
              children: [
                ProjectsSearchBar(),
                Expanded(child: BlocBuilder<ProjectsBloc, AppState>(
                  builder: (context, state) {
                    if (state is Loading) {
                      return ListAnimator(
                        customPadding: EdgeInsets.symmetric(horizontal: 16.w),
                        data: List.generate(
                            10,
                            (index) => Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8.h),
                                  child: CustomShimmerContainer(
                                    height: 125.h,
                                    width: context.w,
                                  ),
                                )),
                      );
                    }
                    if (state is Done) {
                      return Column(
                        children: [
                          Expanded(
                            child: ListAnimator(
                              customPadding:
                                  EdgeInsets.symmetric(horizontal: 16.w),
                              controller:
                                  context.read<ProjectsBloc>().scrollController,
                              data: state.cards,
                            ),
                          ),
                          CustomLoading(
                              isTextLoading: true, loading: state.loading)
                        ],
                      );
                    }
                    if (state is Empty || state is Error) {
                      return EmptyContainer(
                        txt: allTranslations.text("oops"),
                        subText: allTranslations.text(state is Error
                            ? "something_went_wrong"
                            : "there_is_no_data"),
                      );
                    } else {
                      return SizedBox();
                    }
                  },
                ))
              ],
            );
          },
        ),
      )),
    );
  }
}
