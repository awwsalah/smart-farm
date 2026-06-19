import 'package:app/models/tip.dart';
import 'package:app/widgets/pressable_scale.dart';
import 'package:flutter/material.dart';

class TipCard extends StatelessWidget {
  const TipCard({
    super.key,
    required this.tip,
    required this.onTap,
  });

  final Tip tip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PressableScale(
      onTap: onTap,
      child: SizedBox(
        width: 260,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Text(
                    tip.text,
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}