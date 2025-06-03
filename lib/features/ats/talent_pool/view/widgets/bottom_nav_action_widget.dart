import 'package:eco_system/features/ats/talent_pool/bloc/talent_pool_bloc.dart';
import 'package:eco_system/utility/export.dart';

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
    return BlocBuilder<TalentPoolBloc, AppState>(
      builder: (context, state) {
        final bloc = context.read<TalentPoolBloc>();
        return GestureDetector(
          onTap: () {
            bloc.fileNameController.clear();
            PopUpHelper.showBottomSheet(
                height: height, child: bottomSheetContent);
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
      },
    );
  }
}
