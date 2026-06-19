import 'package:app/config/app_strings.dart';
import 'package:app/providers/cart_provider.dart';
import 'package:app/screens/marketplace/order_summary_screen.dart';
import 'package:app/widgets/empty_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CartProvider>().load();
    });
  }

  void _openOrderSummary() {
    final disableAnimations = MediaQuery.disableAnimationsOf(context);
    Navigator.of(context).push(
      PageRouteBuilder<void>(
        pageBuilder: (_, __, ___) => const OrderSummaryScreen(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: disableAnimations
            ? Duration.zero
            : const Duration(milliseconds: 280),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.cart),
      ),
      body: cart.isLoading && cart.items.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : cart.items.isEmpty
              ? const EmptyState(
                  icon: Icons.shopping_cart_outlined,
                  message: AppStrings.emptyCart,
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.all(12),
                        itemCount: cart.items.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final line = cart.items[index];
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          line.product.name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall
                                              ?.copyWith(
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${line.product.price.toStringAsFixed(2)} ${line.product.currency}',
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${AppStrings.total}: ${line.lineTotal.toStringAsFixed(2)} ${line.product.currency}',
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              context
                                                  .read<CartProvider>()
                                                  .updateQuantity(
                                                    line.cartItemId,
                                                    line.quantity - 1,
                                                  );
                                            },
                                            icon: const Icon(Icons.remove),
                                          ),
                                          Text('${line.quantity}'),
                                          IconButton(
                                            onPressed: () {
                                              context
                                                  .read<CartProvider>()
                                                  .updateQuantity(
                                                    line.cartItemId,
                                                    line.quantity + 1,
                                                  );
                                            },
                                            icon: const Icon(Icons.add),
                                          ),
                                        ],
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          context
                                              .read<CartProvider>()
                                              .removeItem(line.cartItemId);
                                        },
                                        child: const Text(AppStrings.remove),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SafeArea(
                      minimum: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppStrings.total,
                                style:
                                    Theme.of(context).textTheme.titleMedium,
                              ),
                              Text(
                                '${cart.total.toStringAsFixed(2)} USD',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          FilledButton(
                            onPressed: _openOrderSummary,
                            child: const Text(AppStrings.order),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }
}