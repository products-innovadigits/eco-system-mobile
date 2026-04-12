import '../../shared/strategy_exports.dart';

class BscView extends StatelessWidget {
  const BscView({super.key});

  @override
  Widget build(BuildContext context) {
    // [BscBloc] is provided app-wide from [StrategyModule] (same instance as strategy home).
    return Scaffold(
      appBar: CustomAppBar(title: allTranslations.text(LocaleKeys.bsc)),
      body: BlocBuilder<BscBloc, AppState>(
        builder: (context, state) {
          return switch (state) {
            // Loading
            Loading() => const ShimmerCardsList(),

            // Done
            Done(:final data) => _BscBody(
              visionData: data as VisionDataModel,
            ),

            // Empty
            Empty() => const EmptyContainer(),

            // error / anything else
            _ => EmptyContainer(
              txt: allTranslations.text(LocaleKeys.something_went_wrong),
              img: Assets.svgs.error.path,
            ),
          };
        },
      ),
    );
  }
}

class _BscBody extends StatelessWidget {
  final VisionDataModel visionData;

  const _BscBody({required this.visionData});

  @override
  Widget build(BuildContext context) {
    return ListAnimator(
      customPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      data: [
        /// Vision, Mission, Values
        VisionSection(
          visionTitle: visionData.title ?? '',
          values: visionData.values ?? [],
          messages: visionData.missions ?? [],
        ),
        SizedBox(height: 24.h),
        // StrategicAxesSection(...)  // keep commented if not used
        // SizedBox(height: 24.h),
        /// Perspectives Section
        PerspectivesSection(perspectives: (visionData.manzors ?? [])),
      ],
    );
  }
}
