import 'package:app/config/app_strings.dart';
import 'package:app/providers/connectivity_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectivityProvider>(
      builder: (context, connectivity, _) {
        if (connectivity.isOnline) {
          return const SizedBox.shrink();
        }

        final theme = Theme.of(context);

        return Material(
          color: theme.colorScheme.errorContainer,
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Icon(
                    Icons.cloud_off_outlined,
                    size: 20,
                    color: theme.colorScheme.onErrorContainer,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.offline,
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: theme.colorScheme.onErrorContainer,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          AppStrings.offlineBannerHint,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onErrorContainer,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed:
                        connectivity.isChecking ? null : connectivity.check,
                    child: Text(AppStrings.retry),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}