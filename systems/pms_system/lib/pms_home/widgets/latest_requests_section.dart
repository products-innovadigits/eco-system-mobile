import 'package:pms_system/pms_home/widgets/request_card_widget.dart';

import '../../shared/pms_exports.dart';

class LatestRequestsSection extends StatelessWidget {
  const LatestRequestsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return MainCardWidget(
      title: allTranslations.text(LocaleKeys.latest_requests),
      moreBtnTxt: allTranslations.text(LocaleKeys.view_more),
      onViewMoreTap: () {},
      child: Column(
        children: List.generate(4, (i) {
          return const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: RequestCardWidget(),
          );
        }),
      ),
    );
  }
}
