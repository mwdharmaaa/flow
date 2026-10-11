import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flow/core/theme/app_theme.dart';

class VoiceWaveformVisualizer extends StatefulWidget {
  final bool isListening;

  const VoiceWaveformVisualizer({super.key, required this.isListening});

  @override
  State<VoiceWaveformVisualizer> createState() => _VoiceWaveformVisualizerState();
}

class _VoiceWaveformVisualizerState extends State<VoiceWaveformVisualizer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    if (widget.isListening) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant VoiceWaveformVisualizer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isListening != oldWidget.isListening) {
      if (widget.isListening) {
        _controller.repeat();
      } else {
        _controller.stop();
        _controller.reset();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(12, (index) {
              final phase = (index / 12) * 2 * math.pi;
              final wave = math.sin(_controller.value * 2 * math.pi + phase).abs();
              final height = widget.isListening
                  ? 12.0 + (wave * 36.0)
                  : 6.0;

              return Container(
                width: 4,
                height: height,
                margin: const EdgeInsets.symmetric(horizontal: 2.5),
                decoration: BoxDecoration(
                  color: widget.isListening
                      ? AppTheme.primary
                      : AppTheme.subtle.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: widget.isListening
                      ? [
                          BoxShadow(
                            color: AppTheme.primary.withValues(alpha: 0.4),
                            blurRadius: 4,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
              );
            }),
          ),
        );
      },
    ),
  );
}
}
