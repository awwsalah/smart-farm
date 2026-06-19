import 'package:flutter/material.dart';

class CartBadgeIcon extends StatefulWidget {
  const CartBadgeIcon({
    super.key,
    required this.count,
    required this.onPressed,
  });

  final int count;
  final VoidCallback onPressed;

  @override
  State<CartBadgeIcon> createState() => _CartBadgeIconState();
}

class _CartBadgeIconState extends State<CartBadgeIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;
  int _previousCount = 0;

  @override
  void initState() {
    super.initState();
    _previousCount = widget.count;
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _bounceAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.35), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.35, end: 1.0), weight: 50),
    ]).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeOut),
    );
  }

  @override
  void didUpdateWidget(CartBadgeIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.count > _previousCount &&
        !MediaQuery.disableAnimationsOf(context)) {
      _bounceController.forward(from: 0);
    }
    _previousCount = widget.count;
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: widget.onPressed,
      icon: ScaleTransition(
        scale: _bounceAnimation,
        child: Badge(
          isLabelVisible: widget.count > 0,
          label: Text('${widget.count}'),
          child: const Icon(Icons.shopping_cart_outlined),
        ),
      ),
    );
  }
}