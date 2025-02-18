import 'dart:async';
import 'package:eco_system/features/objectives/bloc/objectives_bloc.dart';
import 'package:eco_system/features/objectives/widgets/strategic_axis_filter.dart';
import 'package:eco_system/helpers/translation/all_translation.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../components/custom_text_field.dart';
import '../../../core/app_event.dart';
import '../../../core/app_state.dart';
import '../../../helpers/styles.dart';
import '../../../model/search_engine.dart';

class ObjectivesSearchBar extends StatefulWidget {
  const ObjectivesSearchBar({super.key});

  @override
  State<ObjectivesSearchBar> createState() => _ObjectivesSearchBarState();
}

class _ObjectivesSearchBarState extends State<ObjectivesSearchBar> {
  Timer? timer;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ObjectivesBloc, AppState>(
      builder: (context, state) {
        return StreamBuilder(
          stream: context.read<ObjectivesBloc>().goingDownStream,
          builder: (context, snapshot) {
            return AnimatedCrossFade(
              crossFadeState: snapshot.data == true
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              duration: const Duration(milliseconds: 400),
              firstChild: SizedBox(width: context.w),
              secondChild: Padding(
                padding: EdgeInsets.only(
                  left: 16.w,
                  right: 16.w,
                  top: 16.h,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 5,
                      child: CustomTextField(
                        hint: allTranslations.text("search_hint"),
                        controller: context.read<ObjectivesBloc>().searchTEC,
                        prefixSvg: "search",
                        borderColor: Styles.LIGHT_GREY_BORDER,
                        addBorder: true,
                        onChanged: (v) {
                          if (timer != null) if (timer!.isActive)
                            timer!.cancel();
                          timer = Timer(
                            const Duration(milliseconds: 400),
                            () {
                              context
                                  .read<ObjectivesBloc>()
                                  .add(Click(arguments: SearchEngine()));
                            },
                          );
                        },
                        onSaved: (v) {
                          context
                              .read<ObjectivesBloc>()
                              .add(Click(arguments: SearchEngine()));
                        },
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                        flex: 3,
                        child: StrategicAxisFilter(
                          initialSelection:
                              context.read<ObjectivesBloc>().filter.valueOrNull,
                          onSelect: (v) {
                            context.read<ObjectivesBloc>().updateFilter(v);
                            context
                                .read<ObjectivesBloc>()
                                .add(Click(arguments: SearchEngine()));
                          },
                        )),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
