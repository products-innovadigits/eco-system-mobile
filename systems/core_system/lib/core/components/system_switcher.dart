import 'package:core_system/core/utility/export.dart';

class SystemsSwitcher extends StatefulWidget {
  final ActiveSystemEnum? systemEnum;
  final VoidCallback? onComplete;

  const SystemsSwitcher({super.key, this.systemEnum, this.onComplete});

  @override
  State<SystemsSwitcher> createState() => _SystemsSwitcherState();
}

class _SystemsSwitcherState extends State<SystemsSwitcher>
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
        // Notify parent that transition is complete
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

  String _withSystemName(String key) => allTranslations
      .text(key)
      .replaceAll('{system}', SystemHelper.getSystemName(widget.systemEnum));

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
                    child: Images(image: Assets.svgs.logo.path),
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
                _withSystemName(LocaleKeys.switching_to_system),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                _withSystemName(LocaleKeys.switching_to_system_hint),
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
