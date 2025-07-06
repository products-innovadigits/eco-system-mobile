
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
          style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const Spacer(),
        GestureDetector(
            onTap: () => CustomNavigator.pop(),
            child: Images(image: Assets.svgs.closeSquare.path)),
      ],
    );
  }
}
