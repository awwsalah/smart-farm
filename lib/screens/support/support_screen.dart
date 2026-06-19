import 'package:app/config/app_strings.dart';
import 'package:app/config/app_theme.dart';
import 'package:app/config/support_faq.dart';
import 'package:app/config/seller_contact.dart';
import 'package:app/widgets/app_background.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  Future<void> _launchPhone() async {
    final uri = Uri.parse('tel:${SellerContact.phone}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _launchWhatsApp() async {
    final uri = Uri.parse(
      'https://wa.me/${SellerContact.whatsApp}?text=${Uri.encodeComponent('Salaan, waxaan u baahanahay caawimaad beeraha.')}',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppTheme.gradientAppBar(title: AppStrings.supportScreenTitle),
      body: AppBackground(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              AppStrings.supportIntro,
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _launchPhone,
              icon: const Icon(Icons.phone),
              label: const Text(AppStrings.callSupport),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _launchWhatsApp,
              icon: const Icon(Icons.chat),
              label: const Text(AppStrings.whatsAppSupport),
            ),
            const SizedBox(height: 28),
            Text(
              AppStrings.supportFaqTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 12),
            ...SupportFaq.items.map((item) {
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ExpansionTile(
                  title: Text(
                    item.question,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          item.answer,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}