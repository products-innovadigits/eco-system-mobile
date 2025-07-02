import 'package:ats_package/shared/ats_exports.dart';
import 'package:core_package/core/utility/export.dart';

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
            bottomSheetContent: BlocBuilder<TalentPoolBloc, AppState>(
              builder: (context, state) {
                final bloc = context.read<TalentPoolBloc>();
                return Stack(
                  children: [
                    Column(
                      children: [
                        BottomSheetHeader(title: LocaleKeys.assign_to_job),
                        AssignToJobList(
                            onSelectJob: (jobs) {
                              bloc.selectedJobsList = jobs;
                            },
                            selectedJobsList: bloc.selectedJobsList),
                        52.sh,
                      ],
                    ),
                    Positioned(
                      bottom: 0,
                      child: CustomBtn(
                          width: context.w * 0.9,
                          loading: state is Exporting,
                          text: allTranslations.text(LocaleKeys.save),
                          onPressed: () {
                            context.read<TalentPoolBloc>().add(Assign());
                          }),
                    )
                  ],
                );
              },
            ),
          ),
          BottomNavActionWidget(
            icon: Assets.svgs.documentDownload.path,
            title: LocaleKeys.export_zip,
            bottomSheetContent: BlocBuilder<TalentPoolBloc, AppState>(
              builder: (context, state) {
                final bloc = context.read<TalentPoolBloc>();
                return Column(
                  children: [
                    BottomSheetHeader(title: LocaleKeys.export_zip),
                    24.sh,
                    CustomTextField(
                      hint: allTranslations.text(LocaleKeys.enter_file_name),
                      label: allTranslations.text(LocaleKeys.file_name),
                      controller: bloc.fileNameController,
                    ),
                    16.sh,
                    CustomBtn(
                        text: allTranslations.text(LocaleKeys.save),
                        loading: state is Exporting,
                        onPressed: () {
                          bloc.add(Export(arguments: false));
                        })
                  ],
                );
              },
            ),
          ),
          BottomNavActionWidget(
            icon: Assets.svgs.export.path,
            title: LocaleKeys.export_excel,
            bottomSheetContent: BlocBuilder<TalentPoolBloc, AppState>(
              builder: (context, state) {
                final bloc = context.read<TalentPoolBloc>();
                return Column(
                  children: [
                    BottomSheetHeader(title: LocaleKeys.export_excel),
                    24.sh,
                    CustomTextField(
                      hint: allTranslations.text(LocaleKeys.enter_file_name),
                      label: allTranslations.text(LocaleKeys.file_name),
                      controller: bloc.fileNameController,
                    ),
                    16.sh,
                    CustomBtn(
                        text: allTranslations.text(LocaleKeys.save),
                        loading: state is Exporting,
                        onPressed: () {
                          bloc.add(Export(arguments: true));
                        })
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
