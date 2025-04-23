import 'package:eco_system/components/custom_btn.dart';
import 'package:eco_system/components/custom_text_field.dart';
import 'package:eco_system/core/app_strings/locale_keys.dart';
import 'package:eco_system/core/assets.gen.dart';
import 'package:eco_system/features/ats/talent_pool/bloc/talent_pool_bloc.dart';
import 'package:eco_system/features/ats/talent_pool/view/widgets/assign_to_job_list.dart';
import 'package:eco_system/features/ats/talent_pool/view/widgets/bottom_nav_action_widget.dart';
import 'package:eco_system/helpers/styles.dart';
import 'package:eco_system/helpers/translation/all_translation.dart';
import 'package:eco_system/utility/extensions.dart';
import 'package:eco_system/widgets/bottom_sheet_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TalentPoolBottomNav extends StatelessWidget {
  const TalentPoolBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
          border: Border.all(color: Styles.BORDER),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          color: Styles.WHITE_COLOR),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          BottomNavActionWidget(
            icon: Assets.svgs.directboxSend.path,
            title: LocaleKeys.assign_to_job,
            height: context.h * 0.8,
            bottomSheetContent: Stack(
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
          ),
          BottomNavActionWidget(
            icon: Assets.svgs.documentDownload.path,
            title: LocaleKeys.export_zip,
            bottomSheetContent: Column(
              children: [
                BottomSheetHeader(title: LocaleKeys.export_zip,),
                24.sh,
                CustomTextField(
                  hint: allTranslations.text(LocaleKeys.enter_file_name),
                  label: allTranslations.text(LocaleKeys.file_name),
                  controller: context.read<TalentPoolBloc>().fileNameController,
                ),
                16.sh,
                CustomBtn(
                    text: allTranslations.text(LocaleKeys.save),
                    onPressed: () {})
              ],
            ),
          ),
          BottomNavActionWidget(
            icon: Assets.svgs.export.path,
            title: LocaleKeys.export_excel,
            bottomSheetContent: Column(
              children: [
                BottomSheetHeader(
                    title: LocaleKeys.export_excel),
                24.sh,
                CustomTextField(
                  hint: allTranslations.text(LocaleKeys.enter_file_name),
                  label: allTranslations.text(LocaleKeys.file_name),
                  controller: context.read<TalentPoolBloc>().fileNameController,
                ),
                16.sh,
                CustomBtn(
                    text: allTranslations.text(LocaleKeys.save),
                    onPressed: () {})
              ],
            ),
          ),
        ],
      ),
    );
  }
}
