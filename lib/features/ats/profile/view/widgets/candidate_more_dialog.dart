import 'package:eco_system/utility/export.dart';

class CandidateMoreDialog extends StatelessWidget {
  const CandidateMoreDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, AppState>(
      builder: (context, state) {
        // final profileBloc = context.read<ProfileBloc>();
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
                              AssignToJobList(
                                onSelectJob: (int) {},
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
              ],
            ),
          ),
        );
      },
    );
  }
}
