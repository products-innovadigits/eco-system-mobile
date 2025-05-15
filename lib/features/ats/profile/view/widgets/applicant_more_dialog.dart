
import 'package:eco_system/utility/export.dart';

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
