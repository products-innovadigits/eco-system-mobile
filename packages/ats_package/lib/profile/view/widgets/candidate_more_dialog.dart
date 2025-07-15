import 'package:ats_package/profile/view/widgets/more_dialog_tile_widget.dart';
import 'package:ats_package/shared/ats_exports.dart';
import 'package:core_package/core/utility/export.dart';

class CandidateMoreDialog extends StatelessWidget {
  final int candidateId;

  const CandidateMoreDialog({super.key, required this.candidateId});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(left: 16.w, top: 46.h),
        decoration: BoxDecoration(
          color: context.color.surfaceContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MoreDialogTileWidget(
              title: LocaleKeys.assign_to_job,
              iconPath: Assets.svgs.directboxSend.path,
              dividerColor: Colors.transparent,
              onTap: () {
                PopUpHelper.showBottomSheet(
                  height: context.h * 0.8,
                  child: BlocProvider.value(
                    value: context.read<ProfileBloc>(),
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            BottomSheetHeader(title: allTranslations.text(LocaleKeys.assign_to_job)),
                            24.sh,
                            AssignToJobList(
                                onSelectJob: (jobs) {
                                  context.read<ProfileBloc>().selectedJobsList =
                                      jobs;
                                },
                                selectedJobsList: context
                                    .read<ProfileBloc>()
                                    .selectedJobsList),
                            52.sh,
                          ],
                        ),
                        BlocBuilder<ProfileBloc, AppState>(
                          builder: (context, state) {
                            final bloc = context.read<ProfileBloc>();
                            return Positioned(
                              bottom: 0,
                              child: CustomBtn(
                                  width: context.w * 0.9,
                                  loading: state is Exporting,
                                  text: allTranslations.text(LocaleKeys.save),
                                  onPressed: () {
                                    bloc.add(Assign(arguments: candidateId));
                                  }),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
