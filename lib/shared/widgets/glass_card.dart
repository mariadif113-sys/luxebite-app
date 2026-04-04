import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:flutter_animate/flutter_animate.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final double borderRadius;
  final double blur;
  final Color? borderColor;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.width,
    this.height,
    this.borderRadius = 32,
    this.blur = 15,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GlassmorphicContainer(
      width: width ?? double.infinity,
      height: height ?? double.infinity,
      borderRadius: borderRadius,
      blur: blur,
      alignment: Alignment.center,
      border: 1,
      linearGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          theme.brightness == Brightness.dark 
            ? Colors.white.withValues(alpha: 0.08) 
            : Colors.black.withValues(alpha: 0.04),
          theme.brightness == Brightness.dark 
            ? Colors.white.withValues(alpha: 0.03) 
            : Colors.black.withValues(alpha: 0.01),
        ],
      ),
      borderGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          (borderColor ?? theme.primaryColor).withValues(alpha: 0.4),
          (borderColor ?? theme.primaryColor).withValues(alpha: 0.1),
        ],
      ),
      child: Padding(
        padding: padding ?? EdgeInsets.zero,
        child: child,
      ),
    ).animate(onPlay: (controller) => controller.repeat())
     .shimmer(
       duration: 3000.ms, 
       color: (borderColor ?? theme.primaryColor).withValues(alpha: 0.1),
       angle: 45,
     );
  }
}
