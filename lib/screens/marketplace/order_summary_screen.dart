import 'package:app/config/app_strings.dart';
import 'package:app/config/app_theme.dart';
import 'package:app/config/seller_contact.dart';
import 'package:app/providers/cart_provider.dart';
import 'package:app/widgets/app_background.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderSummaryScreen extends StatelessWidget {
  const OrderSummaryScreen({super.key});

  Future<void> _launchPhone() async {
    final uri = Uri.parse('tel:${SellerContact.phone}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _launchWhatsApp(BuildContext context) async {
    final cart = context.read<CartProvider>();
    final buffer = StringBuffer('Salaan, waxaan rabaa inaan dalbo:\n');

    for (final line in cart.items) {
      buffer.writeln(
        '- ${line.product.name} x${line.quantity} (${line.lineTotal.toStringAsFixed(2)} ${line.product.currency})',
      );
    }
    buffer.writeln('${AppStrings.total}: ${cart.total.toStringAsFixed(2)} USD');

    final uri = Uri.parse(
      'https://wa.me/${SellerContact.whatsApp}?text=${Uri.encodeComponent(buffer.toString())}',
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppTheme.gradientAppBar(title: AppStrings.orderSummary),
      body: AppBackground(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              AppStrings.orderPlaced,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              AppStrings.orderPlacedHint,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textMuted,
                  ),
            ),
            const SizedBox(height: 24),
            ...cart.items.map((line) {
              return Card(
                child: ListTile(
                  title: Text(line.product.name),
                  subtitle: Text(
                    '${line.quantity} x ${line.product.price.toStringAsFixed(2)} ${line.product.currency}',
                  ),
                  trailing: Text(
                    '${line.lineTotal.toStringAsFixed(2)} ${line.product.currency}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              );
            }),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppStrings.total,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  '${cart.total.toStringAsFixed(2)} USD',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _launchPhone,
              icon: const Icon(Icons.phone),
              label: const Text(AppStrings.callSeller),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => _launchWhatsApp(context),
              icon: const Icon(Icons.chat),
              label: const Text(AppStrings.whatsAppSeller),
            ),
          ],
        ),
      ),
    );
  }
}