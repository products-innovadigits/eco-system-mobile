import 'package:core_package/core/utility/export.dart';
import 'package:strategy_package/bsc/bloc/bsc_bloc.dart';
import 'package:strategy_package/bsc/widgets/vision_section.dart';

import '../widgets/perspectives_section.dart';
import '../widgets/strategic_axes_section.dart';

class BscView extends StatelessWidget {
  const BscView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BscBloc()..add(Click()),
      child: Scaffold(
        appBar: CustomAppBar(title: allTranslations.text(LocaleKeys.bsc)),
        body: BlocBuilder<BscBloc, AppState>(
          builder: (context, state) {
            cprint('BSC state: ================= $state');
            if (state is Loading || state is Start) {
              return ListAnimator(
                customPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 16.h,
                ),
                data: List.generate(
                  10,
                  (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: CustomShimmerContainer(height: 100.h , width: context.w),
                  ),
                ),
              );
            }
            if (state is Done) {
              return ListAnimator(
                customPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 16.h,
                ),
                data: [
                  /// Vision, Mission, Values
                  const VisionSection(),
                  24.sh,

                  /// Strategic Axes Section
                  const StrategicAxesSection(),
                  24.sh,

                  /// Perspectives Section
                  const PerspectivesSection(),
                ],
              );
            } else {
              return EmptyContainer(
                txt: allTranslations.text(LocaleKeys.something_went_wrong),
                img: Assets.svgs.error.path,
              );
            }
          },
        ),
      ),
    );
  }
}
