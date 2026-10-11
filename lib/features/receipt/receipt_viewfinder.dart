import 'package:flutter/material.dart';
import 'package:flow/core/theme/app_theme.dart';

class ReceiptViewfinder extends StatefulWidget {
  final bool isScanning;

  const ReceiptViewfinder({super.key, this.isScanning = false});

  @override
  State<ReceiptViewfinder> createState() => _ReceiptViewfinderState();
}

class _ReceiptViewfinderState extends State<ReceiptViewfinder>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF0F1117),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.darkBorderSubtle),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Corner Guides
          Positioned(
            top: 14,
            left: 14,
            child: _buildCorner(isTop: true, isLeft: true),
          ),
          Positioned(
            top: 14,
            right: 14,
            child: _buildCorner(isTop: true, isLeft: false),
          ),
          Positioned(
            bottom: 14,
            left: 14,
            child: _buildCorner(isTop: false, isLeft: true),
          ),
          Positioned(
            bottom: 14,
            right: 14,
            child: _buildCorner(isTop: false, isLeft: false),
          ),

          // Scanning Line
          if (widget.isScanning)
            AnimatedBuilder(
              animation: _animController,
              builder: (context, child) {
                return Positioned(
                  top: 20 + (_animController.value * 140),
                  left: 20,
                  right: 20,
                  child: Container(
                    height: 2,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.primary.withValues(alpha: 0.1),
                          AppTheme.primary,
                          AppTheme.primary.withValues(alpha: 0.1),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primary.withValues(alpha: 0.6),
                          blurRadius: 6,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

          // Central Icon & Instruction
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.document_scanner_outlined,
                color: widget.isScanning ? AppTheme.primary : Colors.white54,
                size: 38,
              ),
              const SizedBox(height: 8),
              Text(
                widget.isScanning
                    ? 'Memproses Optical Character Recognition (OCR)...'
                    : 'Posisikan struk belanja di dalam kotak sensor',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white70,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCorner({required bool isTop, required bool isLeft}) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        border: Border(
          top: isTop
              ? const BorderSide(color: AppTheme.primary, width: 2.5)
              : BorderSide.none,
          bottom: !isTop
              ? const BorderSide(color: AppTheme.primary, width: 2.5)
              : BorderSide.none,
          left: isLeft
              ? const BorderSide(color: AppTheme.primary, width: 2.5)
              : BorderSide.none,
          right: !isLeft
              ? const BorderSide(color: AppTheme.primary, width: 2.5)
              : BorderSide.none,
        ),
      ),
    );
  }
}
