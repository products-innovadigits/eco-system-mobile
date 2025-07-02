import 'package:core_package/core/utility/export.dart';

class AnimatedContainerDemo extends StatefulWidget {
  const AnimatedContainerDemo({super.key});

  @override
  State<AnimatedContainerDemo> createState() => _AnimatedContainerDemoState();
}

class _AnimatedContainerDemoState extends State<AnimatedContainerDemo> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Demo 1: Simple height animation
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              height: isExpanded ? 200 : 100,
              width: 200,
              decoration: BoxDecoration(
                color: Styles.PRIMARY_COLOR,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            20.sh,

            // Demo 2: Multiple properties animation
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              height: isExpanded ? 150 : 100,
              width: isExpanded ? 250 : 200,
              decoration: BoxDecoration(
                color: isExpanded ? Styles.DARK_BLUE : Styles.PRIMARY_COLOR,
                borderRadius: BorderRadius.circular(isExpanded ? 20 : 8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isExpanded ? 0.3 : 0.1),
                    blurRadius: isExpanded ? 10 : 5,
                    offset: Offset(0, isExpanded ? 5 : 2),
                  ),
                ],
              ),
            ),
            20.sh,

            // Toggle button
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
              child: Text(
                isExpanded ? 'Collapse' : 'Expand',
                style: AppTextStyles.w500.copyWith(color: Styles.WHITE_COLOR),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
