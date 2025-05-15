import 'package:eco_system/components/custom_btn.dart';
import 'package:eco_system/core/app_state.dart';
import 'package:eco_system/core/app_strings/locale_keys.dart';
import 'package:eco_system/core/assets.gen.dart';
import 'package:eco_system/features/ats/profile/bloc/profile_bloc.dart';
import 'package:eco_system/features/ats/profile/view/widgets/more_dialog_tile_widget.dart';
import 'package:eco_system/features/ats/talent_pool/view/widgets/assign_to_job_list.dart';
import 'package:eco_system/helpers/popup_helper.dart';
import 'package:eco_system/helpers/translation/all_translation.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:eco_system/widgets/bottom_sheet_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CandidateMoreDialog extends StatelessWidget {
  const CandidateMoreDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, AppState>(
      builder: (context, state) {
        final profileBloc = context.read<ProfileBloc>();
        return SafeArea(
          child: Container(
            margin: EdgeInsets.only(left: 16.w, top: 46.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MoreDialogTileWidget(
                  title: LocaleKeys.assign_to_job,
                  iconPath: Assets.svgs.directboxSend.path,
                  onTap: () {
                    PopUpHelper.showBottomSheet(
                      height: context.h * 0.8,
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              BottomSheetHeader(
                                  title: LocaleKeys.assign_to_job),
                              24.sh,
                              AssignToJobList(),
                              52.sh,
                            ],
                          ),
                          Positioned(
                            bottom: 0,
                            child: CustomBtn(
                                width: context.w * 0.9,
                                text: allTranslations.text(LocaleKeys.save),
                                onPressed: () {}),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
