import 'package:core_system/core/utility/export.dart';

class SystemsSwitcher extends StatefulWidget {
  final ActiveSystemEnum? systemEnum;

  const SystemsSwitcher({super.key, this.systemEnum});

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
    // Set the current active system
    UserBloc.currentActiveSystem = widget.systemEnum;
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
        // Add a small delay to ensure any chart animations are properly disposed
        Future.delayed(const Duration(milliseconds: 100), () {
          // Navigate to the selected system after loading
          CustomNavigator.push(
            widget.systemEnum == ActiveSystemEnum.strategy
                ? Routes.STRATEGY_LAYOUT
                : widget.systemEnum == ActiveSystemEnum.pms
                ? Routes.PMS_LAYOUT
                : Routes.STRATEGY_LAYOUT,
            clean: true,
          );
        });
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
    return Scaffold(
      body: Padding(
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
                    padding: EdgeInsets.all(16),
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
                        constraints: BoxConstraints(
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
                'الانتقال الي ${SystemHelper.getSystemName(widget.systemEnum)}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'أنت الآن تنتقل  إلى ${SystemHelper.getSystemName(widget.systemEnum)}  — لتجربة أكثر تركيزًا وسلاسة في التخطيط والمتابعة وإنجاز المشاريع.',
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
