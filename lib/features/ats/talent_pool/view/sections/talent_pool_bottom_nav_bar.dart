import 'package:eco_system/utility/export.dart';

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
            bottomSheetContent: BlocProvider(
              create: (_) => JobsBloc(),
              child: BlocBuilder<JobsBloc, AppState>(
                builder: (context, state) {
                  final jobsBloc = context.read<JobsBloc>();
                  return Stack(
                    children: [
                      Column(
                        children: [
                          BottomSheetHeader(title: LocaleKeys.assign_to_job),
                          24.sh,
                          AssignToJobList(
                              onSelectJob: (index) =>
                                  jobsBloc..add(Select(arguments: index)),
                              selectedJobsList: jobsBloc.selectedJobsList),
                          52.sh,
                        ],
                      ),
                      Positioned(
                        bottom: 0,
                        child: CustomBtn(
                            width: context.w * 0.9,
                            text: allTranslations.text(LocaleKeys.save),
                            onPressed: () => CustomNavigator.pop()),
                      )
                    ],
                  );
                },
              ),
            ),
          ),
          BottomNavActionWidget(
            icon: Assets.svgs.documentDownload.path,
            title: LocaleKeys.export_zip,
            bottomSheetContent: Column(
              children: [
                BottomSheetHeader(
                  title: LocaleKeys.export_zip,
                ),
                24.sh,
                CustomTextField(
                  hint: allTranslations.text(LocaleKeys.enter_file_name),
                  label: allTranslations.text(LocaleKeys.file_name),
                  controller: context.read<TalentPoolBloc>().fileNameController,
                ),
                16.sh,
                CustomBtn(
                    text: allTranslations.text(LocaleKeys.save),
                    onPressed: () => CustomNavigator.pop())
              ],
            ),
          ),
          BottomNavActionWidget(
            icon: Assets.svgs.export.path,
            title: LocaleKeys.export_excel,
            bottomSheetContent: Column(
              children: [
                BottomSheetHeader(title: LocaleKeys.export_excel),
                24.sh,
                CustomTextField(
                  hint: allTranslations.text(LocaleKeys.enter_file_name),
                  label: allTranslations.text(LocaleKeys.file_name),
                  controller: context.read<TalentPoolBloc>().fileNameController,
                ),
                16.sh,
                CustomBtn(
                    text: allTranslations.text(LocaleKeys.save),
                    onPressed: () => CustomNavigator.pop())
              ],
            ),
          ),
        ],
      ),
    );
  }
}
