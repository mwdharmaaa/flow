import 'package:flutter/material.dart';

class LiquidGlassContainer extends StatelessWidget {
  final Widget child;
  final bool isDark;
  final double radius;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final double blurSigma;
  final bool elevated;
  final VoidCallback? onTap;

  const LiquidGlassContainer({
    super.key,
    required this.child,
    required this.isDark,
    this.radius = 20.0,
    this.borderRadius,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.blurSigma = 18.0,
    this.elevated = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveRadius = borderRadius ?? BorderRadius.circular(radius);

    Widget content = Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: effectiveRadius,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? (elevated
                  ? [
                      Colors.white.withValues(alpha: 0.14),
                      Colors.white.withValues(alpha: 0.03),
                    ]
                  : [
                      Colors.white.withValues(alpha: 0.09),
                      Colors.white.withValues(alpha: 0.015),
                    ])
              : (elevated
                  ? [
                      Colors.white.withValues(alpha: 0.92),
                      Colors.white.withValues(alpha: 0.70),
                    ]
                  : [
                      Colors.white.withValues(alpha: 0.85),
                      Colors.white.withValues(alpha: 0.55),
                    ]),
        ),
        border: Border.all(
          color: isDark
              ? (elevated
                  ? Colors.white.withValues(alpha: 0.30)
                  : Colors.white.withValues(alpha: 0.18))
              : (elevated
                  ? Colors.white.withValues(alpha: 0.95)
                  : Colors.white.withValues(alpha: 0.75)),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.06),
            blurRadius: elevated ? 22 : 14,
            offset: const Offset(0, 6),
          ),
          if (isDark)
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.06),
              blurRadius: 1,
              offset: const Offset(0, 1),
            ),
        ],
      ),
      child: child,
    );

    if (onTap != null) {
      content = GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: content,
      );
    }

    if (margin != null) {
      content = Padding(
        padding: margin!,
        child: content,
      );
    }

    return content;
  }
}
