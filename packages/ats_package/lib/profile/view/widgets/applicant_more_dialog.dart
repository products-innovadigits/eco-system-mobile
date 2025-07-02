import 'package:ats_package/profile/view/sections/ratings_bottom_sheet.dart';
import 'package:ats_package/profile/view/widgets/more_dialog_tile_widget.dart';
import 'package:ats_package/shared/ats_exports.dart';
import 'package:core_package/core/utility/export.dart';

class ApplicantMoreDialog extends StatelessWidget {
  final String email;

  const ApplicantMoreDialog({super.key, required this.email});

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
                  onTap: () => LauncherHelper.sendEmail(email),
                ),
                MoreDialogTileWidget(
                  title: LocaleKeys.copy_to_job,
                  iconPath: Assets.svgs.copy.path,
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
                              AssignToJobList(
                                onSelectJob: (jobs) {},
                                selectedJobsList: [],
                              ),
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
