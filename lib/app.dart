import 'package:app/config/app_strings.dart';
import 'package:app/config/app_theme.dart';
import 'package:app/providers/cart_provider.dart';
import 'package:app/providers/connectivity_provider.dart';
import 'package:app/providers/weather_provider.dart';
import 'package:app/screens/home/home_screen.dart';
import 'package:app/screens/marketplace/marketplace_screen.dart';
import 'package:app/screens/news/news_screen.dart';
import 'package:app/screens/resources/resources_screen.dart';
import 'package:app/widgets/offline_banner.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BeeralayApp extends StatelessWidget {
  const BeeralayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CartProvider()..load(),
        ),
        ChangeNotifierProvider(
          create: (_) => WeatherProvider()..initialize(),
        ),
        ChangeNotifierProvider(
          create: (_) => ConnectivityProvider()..check(),
        ),
      ],
      child: MaterialApp(
        title: AppStrings.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const _MainShell(),
      ),
    );
  }
}

class _MainShell extends StatefulWidget {
  const _MainShell();

  @override
  State<_MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<_MainShell> with WidgetsBindingObserver {
  int _selectedIndex = 0;

  static const _screens = <Widget>[
    HomeScreen(),
    ResourcesScreen(),
    NewsScreen(),
    MarketplaceScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<ConnectivityProvider>().check();
    }
  }

  void _onTabSelected(int index) {
    if (index == _selectedIndex) return;
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final disableAnimations = MediaQuery.disableAnimationsOf(context);
    final duration = disableAnimations
        ? Duration.zero
        : const Duration(milliseconds: 280);

    return Scaffold(
      body: Column(
        children: [
          const OfflineBanner(),
          Expanded(
            child: AnimatedSwitcher(
              duration: duration,
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
              child: KeyedSubtree(
                key: ValueKey<int>(_selectedIndex),
                child: _screens[_selectedIndex],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onTabSelected,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: AppStrings.navHome,
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: AppStrings.navResources,
          ),
          NavigationDestination(
            icon: Icon(Icons.newspaper_outlined),
            selectedIcon: Icon(Icons.newspaper),
            label: AppStrings.navNews,
          ),
          NavigationDestination(
            icon: Icon(Icons.store_outlined),
            selectedIcon: Icon(Icons.store),
            label: AppStrings.navMarket,
          ),
        ],
      ),
    );
  }
}