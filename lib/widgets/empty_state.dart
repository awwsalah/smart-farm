import 'package:flutter/material.dart';

class EmptyState extends StatefulWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.message,
    this.subtitle,
  });

  final IconData icon;
  final String message;
  final String? subtitle;

  @override
  State<EmptyState> createState() => _EmptyStateState();
}

class _EmptyStateState extends State<EmptyState> {
  double _opacity = 0;

  @override
  void initState() {
    super.initState();
    final disableAnimations = WidgetsBinding
        .instance
        .platformDispatcher
        .accessibilityFeatures
        .disableAnimations;

    if (disableAnimations) {
      _opacity = 1;
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _opacity = 1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedOpacity(
      opacity: _opacity,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.icon,
                size: 72,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                widget.message,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium,
              ),
              if (widget.subtitle != null) ...[
                const SizedBox(height: 8),
                Text(
                  widget.subtitle!,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}