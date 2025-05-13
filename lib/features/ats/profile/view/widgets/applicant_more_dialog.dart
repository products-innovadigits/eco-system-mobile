import 'package:eco_system/core/app_state.dart';
import 'package:eco_system/core/app_strings/locale_keys.dart';
import 'package:eco_system/core/assets.gen.dart';
import 'package:eco_system/features/ats/profile/bloc/profile_bloc.dart';
import 'package:eco_system/features/ats/profile/view/sections/ratings_bottom_sheet.dart';
import 'package:eco_system/features/ats/profile/view/widgets/more_dialog_tile_widget.dart';
import 'package:eco_system/helpers/popup_helper.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ApplicantMoreDialog extends StatelessWidget {
  const ApplicantMoreDialog({super.key});

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
                  title: LocaleKeys.rating,
                  iconPath: Assets.svgs.percentageCircle.path,
                  onTap: () {
                    profileBloc.resetRatingBottomSheetData();
                    PopUpHelper.showBottomSheet(
                        child: BlocProvider.value(
                          value: profileBloc,
                          child: RatingsBottomSheet(),
                        ));
                  },
                ),
                MoreDialogTileWidget(
                  title: LocaleKeys.send_email,
                  iconPath: Assets.svgs.sms.path,
                  onTap: () {},
                ),
                MoreDialogTileWidget(
                  title: LocaleKeys.copy_to_job,
                  iconPath: Assets.svgs.copy.path,
                  onTap: () {},
                ),
                MoreDialogTileWidget(
                  title: LocaleKeys.transfer_to_another_stage,
                  iconPath: Assets.svgs.send.path,
                  onTap: () {},
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
