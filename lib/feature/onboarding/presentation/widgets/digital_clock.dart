import 'package:flutter/material.dart';

class DigitalClock extends StatefulWidget {
  final VoidCallback onPressed;
  final TimeOfDay selectedTime;

  const DigitalClock({
    super.key,
    required this.onPressed,
    required this.selectedTime,
  });

  @override
  State<DigitalClock> createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final timeText =
        '${widget.selectedTime.hour.toString().padLeft(2, '0')}:${widget.selectedTime.minute.toString().padLeft(2, '0')}';

    return GestureDetector(
      onTap: widget.onPressed,
      child: Stack(
        children: [
          // Outer container
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade900, // outer layer
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black87, // inner layer
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(6),
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.95, end: 1.0),
                duration: const Duration(seconds: 1),
                curve: Curves.easeInOut,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: child,
                  );
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  decoration: BoxDecoration(
                    color: Colors.black, // innermost container
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    timeText,
                    style: TextStyle(
                      fontSize: 40,
                      fontFamily: 'Digital',
                      color: Colors.blue,
                      letterSpacing: 4,
                      shadows: const [
                        Shadow(
                          blurRadius: 10,
                          color: Colors.white24,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 🍃 Bottom-right icon
          Positioned(
            bottom: 20,
            right: 24,
            child: Icon(
              Icons.eco,
              color: Colors.lightBlueAccent.withAlpha(100),
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
}
