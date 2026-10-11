import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flow/core/theme/app_theme.dart';

class ReceiptViewfinder extends StatefulWidget {
  final bool isScanning;
  final Uint8List? imageBytes;
  final VoidCallback? onRetake;

  const ReceiptViewfinder({
    super.key,
    this.isScanning = false,
    this.imageBytes,
    this.onRetake,
  });

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
    );
    if (widget.isScanning && widget.imageBytes == null) {
      _animController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant ReceiptViewfinder oldWidget) {
    super.didUpdateWidget(oldWidget);
    final shouldAnimate = widget.isScanning && widget.imageBytes == null;
    final wasAnimating = oldWidget.isScanning && oldWidget.imageBytes == null;
    if (shouldAnimate != wasAnimating) {
      if (shouldAnimate) {
        _animController.repeat(reverse: true);
      } else {
        _animController.stop();
        _animController.reset();
      }
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFF0F1117),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.darkBorderSubtle),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (widget.imageBytes != null)
                Positioned.fill(
                  child: Image.memory(
                    widget.imageBytes!,
                    fit: BoxFit.cover,
                  ),
                ),

              // Corner Guides
              Positioned(top: 14, left: 14, child: _buildCorner(isTop: true, isLeft: true)),
              Positioned(top: 14, right: 14, child: _buildCorner(isTop: true, isLeft: false)),
              Positioned(bottom: 14, left: 14, child: _buildCorner(isTop: false, isLeft: true)),
              Positioned(bottom: 14, right: 14, child: _buildCorner(isTop: false, isLeft: false)),

              // Scanning Line
              if (widget.isScanning && widget.imageBytes == null)
                Positioned(
                  left: 20,
                  right: 20,
                  top: 20,
                  bottom: 20,
                  child: AnimatedBuilder(
                    animation: _animController,
                    builder: (context, child) {
                      return Align(
                        alignment: Alignment(0, -1.0 + (_animController.value * 2.0)),
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
                ),

            // Center Content
            if (widget.imageBytes == null)
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
                        : 'Posisikan kamera ke struk belanja kasir',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

            // Retake Button
            if (widget.imageBytes != null && widget.onRetake != null)
              Positioned(
                top: 10,
                right: 10,
                child: GestureDetector(
                  onTap: widget.onRetake,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.refresh, size: 12, color: Colors.white),
                        SizedBox(width: 4),
                        Text(
                          'Ganti Foto',
                          style: TextStyle(fontSize: 10, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    ),
  );
}

  Widget _buildCorner({required bool isTop, required bool isLeft}) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        border: Border(
          top: isTop ? const BorderSide(color: AppTheme.primary, width: 2.5) : BorderSide.none,
          bottom: !isTop ? const BorderSide(color: AppTheme.primary, width: 2.5) : BorderSide.none,
          left: isLeft ? const BorderSide(color: AppTheme.primary, width: 2.5) : BorderSide.none,
          right: !isLeft ? const BorderSide(color: AppTheme.primary, width: 2.5) : BorderSide.none,
        ),
      ),
    );
  }
}
