import 'package:flutter/material.dart';

class CompletionBorderPainter extends CustomPainter {
  final double percent;
  final Color borderColor;
  final double strokeWidth;
  final double? borderRadius;

  CompletionBorderPainter({
    required this.percent,
    required this.borderColor,
    this.strokeWidth = 8.0,
    this.borderRadius = 12
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1) Compute an inset rectangle so the stroke sits fully inside
    final sw = strokeWidth;
    final rect = Offset(sw / 2, sw / 2) &
        Size(size.width - sw, size.height - sw);

    // 2) Build a path that begins at the top-center of the RRect
    final path = Path()
      // move to top-center
      ..moveTo(rect.left + rect.width / 2, rect.top)
      // draw top edge to the beginning of the top-right corner
      ..lineTo(rect.right - borderRadius!, rect.top)
      // top-right corner arc (clockwise)
      ..arcToPoint(
        Offset(rect.right, rect.top + borderRadius!),
        radius: Radius.circular(borderRadius!),
        clockwise: true,
      )
      // right edge
      ..lineTo(rect.right, rect.bottom - borderRadius!)
      // bottom-right corner
      ..arcToPoint(
        Offset(rect.right - borderRadius!, rect.bottom),
        radius: Radius.circular(borderRadius!),
        clockwise: true,
      )
      // bottom edge
      ..lineTo(rect.left + borderRadius!, rect.bottom)
      // bottom-left corner
      ..arcToPoint(
        Offset(rect.left, rect.bottom - borderRadius!),
        radius: Radius.circular(borderRadius!),
        clockwise: true,
      )
      // left edge
      ..lineTo(rect.left, rect.top + borderRadius!)
      // top-left corner
      ..arcToPoint(
        Offset(rect.left + borderRadius!, rect.top),
        radius: Radius.circular(borderRadius!),
        clockwise: true,
      )
      // complete the top edge back to the start point (top-center)
      ..lineTo(rect.left + rect.width / 2, rect.top);

    // 3) Draw the “track” (full border in low opacity)
    final paintBg = Paint()
      ..color = percent != 0 ? borderColor.withAlpha(100) : Colors.transparent
      ..style = PaintingStyle.stroke
      ..strokeWidth = sw;
    canvas.drawPath(path, paintBg);

    // 4) Draw the progress segment along that path
    if (percent > 0) {
      final metric = path.computeMetrics().first;
      final progressPath = metric.extractPath(
        0,
        metric.length * percent.clamp(0.0, 1.0),
      );
      final paintProgress = Paint()
        ..color = borderColor
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = sw;
      canvas.drawPath(progressPath, paintProgress);
    }
  }

  @override
  bool shouldRepaint(covariant CompletionBorderPainter oldDelegate) {
    return oldDelegate.percent != percent || oldDelegate.borderColor != borderColor;
  }
}
