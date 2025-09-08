import 'package:core_system/core/utility/export.dart';

class SystemsSwitcher extends StatefulWidget {
  final ActiveSystemEnum? systemEnum;

  const SystemsSwitcher({super.key, this.systemEnum});

  @override
  State<SystemsSwitcher> createState() => _SystemsSwitcherState();
}

class _SystemsSwitcherState extends State<SystemsSwitcher> {
  double progress = 0.0;

  void _loadingSystem() {
    Timer.periodic(Duration(milliseconds: 250), (v) {
      if (progress < 1.0) {
        setState(() {
          progress += 0.1; // Increment progress
        });
      } else {
        v.cancel(); // Stop the timer when progress reaches 1.0
        // Navigate to the selected system after loading
        CustomNavigator.push(
          widget.systemEnum == ActiveSystemEnum.strategy
              ? Routes.STRATEGY_LAYOUT
              : widget.systemEnum == ActiveSystemEnum.pms
              ? Routes.PMS_LAYOUT
              : Routes.STRATEGY_LAYOUT,
          clean: true,
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // Set the current active system
    UserBloc.currentActiveSystem = widget.systemEnum;
    _loadingSystem();
  }

  @override
  Widget build(BuildContext context) {
    const double size = 70;
    const double stroke = 5;
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
                  CircularProgressIndicator(
                    value: progress,
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
