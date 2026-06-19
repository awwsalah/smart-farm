import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Staggered fade + slide-up for list/grid items (PRD 12.5).
class StaggeredEntrance extends StatelessWidget {
  const StaggeredEntrance({
    super.key,
    required this.index,
    required this.child,
  });

  final int index;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) {
      return child;
    }

    final delayMs = (index.clamp(0, 8)) * 50;

    return child
        .animate()
        .fadeIn(
          duration: const Duration(milliseconds: 250),
          delay: Duration(milliseconds: delayMs),
        )
        .slideY(
          begin: 0.08,
          end: 0,
          duration: const Duration(milliseconds: 250),
          delay: Duration(milliseconds: delayMs),
          curve: Curves.easeOut,
        );
  }
}