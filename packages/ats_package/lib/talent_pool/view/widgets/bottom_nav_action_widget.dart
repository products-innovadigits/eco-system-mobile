import 'package:core_package/core/utility/export.dart';

import '../../../shared/ats_exports.dart';

class BottomNavActionWidget extends StatelessWidget {
  final String icon;
  final String title;
  final Widget bottomSheetContent;
  final double? height;

  const BottomNavActionWidget(
      {super.key,
      required this.icon,
      required this.title,
      required this.bottomSheetContent,
      this.height});

  @override
  Widget build(BuildContext context) {
    final talentPoolBloc = context.read<TalentPoolBloc>();
    return InkWell(
      onTap: () {
        talentPoolBloc.fileNameController.clear();
        PopUpHelper.showBottomSheet(
            height: height,
            child: BlocProvider.value(
              value: talentPoolBloc,
              child: bottomSheetContent,
            ));
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Images(image: icon, color: Styles.DETAILS),
          8.sh,
          Text(
            allTranslations.text(title),
            style: AppTextStyles.w400
                .copyWith(fontSize: 11, color: Styles.DETAILS),
          )
        ],
      ),
    );
  }
}
