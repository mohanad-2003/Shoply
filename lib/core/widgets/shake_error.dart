import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Wraps [child] and plays a horizontal shake whenever [trigger] changes
/// value (e.g. an error counter incremented on each failed attempt). Used to
/// give invalid input (OTP codes, passwords) a tactile, real-app feel.
class ShakeError extends StatefulWidget {
  const ShakeError({super.key, required this.trigger, required this.child});

  final Object? trigger;
  final Widget child;

  @override
  State<ShakeError> createState() => _ShakeErrorState();
}

class _ShakeErrorState extends State<ShakeError>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 450),
  );

  @override
  void didUpdateWidget(ShakeError oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.trigger != oldWidget.trigger) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value;
        // Decaying sine wave: a few quick oscillations that settle to zero.
        final decay = 1 - t;
        final offset = 10 * decay * math.sin(t * 4 * math.pi);
        return Transform.translate(offset: Offset(offset, 0), child: child);
      },
      child: widget.child,
    );
  }
}
