import 'dart:async';
import 'package:core_system/core/navigation/custom_navigation.dart';
import 'package:flutter/material.dart';

class SystemsSwitcher extends StatefulWidget {
  final String title;
  final String subtitle;
  final String systemRoute;

  const SystemsSwitcher({
    super.key,
    required this.title,
    required this.subtitle,
    required this.systemRoute,
  });

  @override
  State<SystemsSwitcher> createState() => _SystemsSwitcherState();
}

class _SystemsSwitcherState extends State<SystemsSwitcher> {
  double _progress = 0.0;
  Timer? _tick;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _startOneSecondProgress();
  }

  void _startOneSecondProgress() {
    _tick?.cancel();
    _progress = 0.0;
    _navigated = false;

    // 10 ticks -> 1.0 in exactly 1 second
    _tick = Timer.periodic(const Duration(milliseconds: 100), (t) {
      if (!mounted) return;

      final next = (_progress + 0.1);
      setState(() => _progress = next.clamp(0.0, 1.0));

      if (_progress >= 1.0 && !_navigated) {
        _navigated = true;
        _tick?.cancel();
        // Let the UI paint the full ring before navigating
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          CustomNavigator.push(widget.systemRoute);
        });
      }
    });
  }

  @override
  void dispose() {
    _tick?.cancel();
    super.dispose();
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
              value: _progress, // 0 → 1 over 1s
              strokeWidth: stroke,
              color: Theme.of(context).colorScheme.primary,
              backgroundColor:
              Theme.of(context).colorScheme.secondary.withOpacity(0.2),
            ),
          ),
          const SizedBox(height: 12),
          Text(widget.title, style: Theme.of(context).textTheme.titleMedium),
          Text(widget.subtitle, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
