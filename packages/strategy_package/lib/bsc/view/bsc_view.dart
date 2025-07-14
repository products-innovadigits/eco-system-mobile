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
      create: (context) => BscBloc(),
      child: Scaffold(
        appBar: CustomAppBar(title: allTranslations.text(LocaleKeys.bsc)),
        body: ListAnimator(
          customPadding: EdgeInsets.symmetric(horizontal: 16.w , vertical: 16.h),
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
        ),
      ),
    );
  }
}
