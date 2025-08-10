import '../../shared/strategy_exports.dart';

class BscView extends StatelessWidget {
  const BscView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BscBloc(),
      child: Scaffold(
        appBar: CustomAppBar(title: allTranslations.text(LocaleKeys.bsc)),
        body: BlocBuilder<BscBloc, AppState>(
          builder: (context, state) {
            if (state is Loading) {
              return _buildLoadingShimmer();
            } else if (state is Done) {
              VisionDataModel visionData = state.data as VisionDataModel;
              return _buildBscBody(visionData);
            } else if (state is Error) {
              return _buildErrorContainer();
            } else {
              return const EmptyContainer();
            }
          },
        ),
      ),
    );
  }
}

Widget _buildLoadingShimmer() {
  return ListAnimator(
    customPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
    data: List.generate(
      10,
      (index) => Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: CustomShimmerContainer(height: 100.h, width: double.infinity),
      ),
    ),
  );
}

Widget _buildBscBody(VisionDataModel visionData) {
  return ListAnimator(
    customPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
    data: [
      /// Vision, Mission, Values
      VisionSection(
        visionTitle: visionData.title ?? '',
        values: visionData.values ?? [],
        messages: visionData.missions ?? [],
      ),
      24.sh,
      // /// Strategic Axes Section
      // StrategicAxesSection(
      //   axes: visionData.strategicAxises ?? [],
      //   isStrategicAxes: false,
      //   selectedAxes: bscBloc.selectedAxes,
      // ),
      // 24.sh,
      /// Perspectives Section
      PerspectivesSection(perspectives: visionData.manzors ?? []),
    ],
  );
}

Widget _buildErrorContainer() {
  return EmptyContainer(
    txt: allTranslations.text(LocaleKeys.something_went_wrong),
    img: Assets.svgs.error.path,
  );
}
