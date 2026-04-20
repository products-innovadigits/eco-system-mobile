import 'package:strategy_system/shared/strategy_exports.dart';

class StrategySystemSwitcher extends StatefulWidget {
  final VoidCallback? onComplete;

  const StrategySystemSwitcher({super.key, this.onComplete});

  @override
  State<StrategySystemSwitcher> createState() => _StrategySystemSwitcherState();
}

class _StrategySystemSwitcherState extends State<StrategySystemSwitcher>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimation();
  }

  void _setupAnimation() {
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onComplete?.call();
      }
    });

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.stop();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double size = 70;
    const double stroke = 4;
    return Material(
      color: context.color.surface,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Container(
                    height: size,
                    width: size,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: context.color.secondary.withValues(alpha: 0.1),
                    ),
                    child: Images(image: 'assets/zulfi_logo.png'),
                  ),
                  AnimatedBuilder(
                    animation: _progressAnimation,
                    builder: (context, child) {
                      return CircularProgressIndicator(
                        value: _progressAnimation.value,
                        strokeWidth: stroke,
                        constraints: const BoxConstraints(
                          minHeight: size,
                          minWidth: size,
                        ),
                        strokeCap: StrokeCap.round,
                        color: Theme.of(context).colorScheme.primary,
                        backgroundColor: context.color.secondary.withValues(
                          alpha: 0.2,
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'الانتقال الي ${SystemHelper.getSystemName(ActiveSystemEnum.strategy)}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'أنت الآن تنتقل  إلى ${SystemHelper.getSystemName(ActiveSystemEnum.strategy)}  — لتجربة أكثر تركيزًا وسلاسة في التخطيط والمتابعة وإنجاز المشاريع.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: context.color.outlineVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
