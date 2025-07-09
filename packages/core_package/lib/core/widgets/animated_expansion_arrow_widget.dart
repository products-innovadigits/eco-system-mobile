import 'package:core_package/core/utility/export.dart';

class AnimatedExpansionArrowWidget extends StatelessWidget {
  final bool isExpanded;
  const AnimatedExpansionArrowWidget({super.key, required this.isExpanded});

  @override
  Widget build(BuildContext context) {
    return AnimatedRotation(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      turns: isExpanded ? 0.5 : 0,
      child: Icon(
        Icons.keyboard_arrow_down_rounded,
        color: isExpanded
            ? context.color.secondary
            : context.color.outlineVariant,
      ),
    );
  }
}
