import 'package:flutter/material.dart';

class LiquidBackground extends StatelessWidget {
  final Widget child;
  final bool isDark;

  const LiquidBackground({
    super.key,
    required this.child,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: RepaintBoundary(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    color: isDark ? const Color(0xFF08090D) : const Color(0xFFF1F5FB),
                  ),
                ),
                Positioned(
                  top: -120,
                  right: -80,
                  child: IgnorePointer(
                    child: Container(
                      width: 380,
                      height: 380,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: isDark
                              ? [
                                  const Color(0xFF1D61E0).withValues(alpha: 0.30),
                                  const Color(0xFF3B82F6).withValues(alpha: 0.12),
                                  Colors.transparent,
                                ]
                              : [
                                  const Color(0xFF60A5FA).withValues(alpha: 0.28),
                                  const Color(0xFF93C5FD).withValues(alpha: 0.10),
                                  Colors.transparent,
                                ],
                          stops: const [0.0, 0.5, 1.0],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 260,
                  left: -100,
                  child: IgnorePointer(
                    child: Container(
                      width: 340,
                      height: 340,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: isDark
                              ? [
                                  const Color(0xFF06B6D4).withValues(alpha: 0.20),
                                  const Color(0xFF10B981).withValues(alpha: 0.08),
                                  Colors.transparent,
                                ]
                              : [
                                  const Color(0xFF38BDF8).withValues(alpha: 0.22),
                                  const Color(0xFF34D399).withValues(alpha: 0.08),
                                  Colors.transparent,
                                ],
                          stops: const [0.0, 0.55, 1.0],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 30,
                  right: -70,
                  child: IgnorePointer(
                    child: Container(
                      width: 400,
                      height: 400,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: isDark
                              ? [
                                  const Color(0xFF6366F1).withValues(alpha: 0.22),
                                  const Color(0xFF8B5CF6).withValues(alpha: 0.07),
                                  Colors.transparent,
                                ]
                              : [
                                  const Color(0xFF818CF8).withValues(alpha: 0.20),
                                  const Color(0xFFA78BFA).withValues(alpha: 0.06),
                                  Colors.transparent,
                                ],
                          stops: const [0.0, 0.5, 1.0],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Content
        child,
      ],
    );
  }
}
