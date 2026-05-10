import 'dart:ui';
import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class GlassCard extends StatelessWidget {
  final Widget child; final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius; final double blurAmount;
  const GlassCard({super.key, required this.child,
      this.padding, this.borderRadius, this.blurAmount = 12});

  @override
  Widget build(BuildContext context) {
    final br = borderRadius ?? BorderRadius.circular(16);
    return ClipRRect(
      borderRadius: br,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurAmount, sigmaY: blurAmount),
        child: Container(
          padding: padding ?? const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: br,
            color: AppColors.glassWhite,
            border: Border.all(color: AppColors.glassBorder, width: 1),
            gradient: const LinearGradient(
              begin: Alignment.topLeft, end: Alignment.bottomRight,
              colors: [AppColors.glassBg, Colors.transparent]),
          ),
          child: child,
        ),
      ),
    );
  }
}
