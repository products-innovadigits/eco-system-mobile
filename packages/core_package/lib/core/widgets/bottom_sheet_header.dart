
import '../utility/export.dart';

class BottomSheetHeader extends StatelessWidget {
  final String title;

  const BottomSheetHeader({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          allTranslations.text(title),
          style: AppTextStyles.w700.copyWith(fontSize: 16),
        ),
        const Spacer(),
        GestureDetector(
            onTap: () => CustomNavigator.pop(),
            child: Images(image: Assets.svgs.closeSquare.path)),
      ],
    );
  }
}
