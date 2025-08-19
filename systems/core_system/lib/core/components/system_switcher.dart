import 'package:core_system/core/utility/export.dart';

class SystemsSwitcher extends StatefulWidget {
  final String systemRoute;

  const SystemsSwitcher({super.key, required this.systemRoute});

  @override
  State<SystemsSwitcher> createState() => _SystemsSwitcherState();
}

class _SystemsSwitcherState extends State<SystemsSwitcher> {
  double progress = 0.0;

  double _loadingSystem() {
    for (progress = 0; progress == 1; progress += 0.01) {
      setState(() {});
    }
    return progress;
  }

  @override
  Widget build(BuildContext context) {
    const double size = 80;
    const double stroke = 5;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: size,
            width: size,
            child: CircularProgressIndicator(
              value: _loadingSystem(),
              strokeWidth: stroke,
              color: Theme.of(context).colorScheme.primary,
              backgroundColor: context.color.secondary.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'الانتقال الي نظام إدارة المشاريع',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text(
            'أنت الآن تنتقل  إلى نظام إدارة المشاريع  — لتجربة أكثر تركيزًا وسلاسة في التخطيط والمتابعة وإنجاز المشاريع.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
