import 'package:app/config/app_strings.dart';
import 'package:flutter/material.dart';

class AnimatedTemperature extends StatelessWidget {
  const AnimatedTemperature({
    super.key,
    required this.celsius,
    this.style,
  });

  final double celsius;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final label = '${celsius.round()}${AppStrings.degreesCelsius}';

    if (MediaQuery.disableAnimationsOf(context)) {
      return Text(label, style: style);
    }

    return TweenAnimationBuilder<double>(
      key: ValueKey<int>(celsius.round()),
      tween: Tween<double>(begin: 0, end: celsius),
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOut,
      builder: (context, value, _) {
        return Text(
          '${value.round()}${AppStrings.degreesCelsius}',
          style: style,
        );
      },
    );
  }
}