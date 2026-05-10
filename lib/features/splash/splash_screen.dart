import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400))
      ..repeat(reverse: true);
    Future.delayed(const Duration(milliseconds: 2800), () {
      if (mounted) context.go('/home');
    });
  }

  @override
  void dispose() { _pulse.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _pulse,
              builder: (_, child) => Container(
                width: 100, height: 100,
                decoration: BoxDecoration(
                  shape:    BoxShape.circle,
                  gradient: AppColors.neonGrad,
                  boxShadow: [BoxShadow(
                    color:        AppColors.primaryGlow,
                    blurRadius:   20 + 20 * _pulse.value,
                    spreadRadius: 4  + 4  * _pulse.value,
                  )],
                ),
                child: child,
              ),
              child: const Icon(Icons.graphic_eq, color: Colors.white, size: 48),
            )
                .animate()
                .scale(duration: 600.ms, curve: Curves.elasticOut)
                .fadeIn(duration: 400.ms),
            const SizedBox(height: 28),
            const Text('HexTunes',
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.w700,
                color: AppColors.textPrimary, letterSpacing: -1))
                .animate(delay: 300.ms)
                .slideY(begin: 0.3, duration: 500.ms, curve: Curves.easeOut)
                .fadeIn(),
            const SizedBox(height: 8),
            const Text('Feel Every Beat',
              style: TextStyle(fontSize: 15, color: AppColors.textSecondary,
                letterSpacing: 1.5))
                .animate(delay: 500.ms).fadeIn(duration: 600.ms),
            const SizedBox(height: 60),
            _LoadingDots().animate(delay: 800.ms).fadeIn(duration: 400.ms),
          ],
        ),
      ),
    );
  }
}

class _LoadingDots extends StatefulWidget {
  @override State<_LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<_LoadingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this,
        duration: const Duration(milliseconds: 900))..repeat();
  }
  @override void dispose() { _ctrl.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => Row(mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (i) {
          final t = (_ctrl.value - i * 0.2).clamp(0.0, 1.0);
          final scale = 0.5 + 0.5 *
              (1 - (t - 0.5).abs() * 2).clamp(0.0, 1.0);
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: 8, height: 8,
            decoration: BoxDecoration(shape: BoxShape.circle,
              color: AppColors.primary.withOpacity(0.4 + 0.6 * scale)));
        })),
    );
  }
}
