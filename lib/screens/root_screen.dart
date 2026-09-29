import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import 'coupons_screen.dart';
import 'home_screen.dart';
import 'map_screen.dart';
import 'quiz_screen.dart';
import 'scan_screen.dart';

// 下タブでスタンプ帳・QR読取・クイズ・クーポン・地図を切り替える（Vue版のApp.vueと同じ構成）
class RootScreen extends StatelessWidget {
  const RootScreen({super.key});

  static const _screens = [
    HomeScreen(),
    ScanScreen(),
    QuizScreen(),
    CouponsScreen(),
    MapScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return Scaffold(
      body: IndexedStack(index: appState.currentTabIndex, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: appState.currentTabIndex,
        onDestinationSelected: appState.goToTab,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.menu_book), label: 'スタンプ帳'),
          NavigationDestination(icon: Icon(Icons.qr_code_scanner), label: 'QR読取'),
          NavigationDestination(icon: Icon(Icons.help_outline), label: 'クイズ'),
          NavigationDestination(icon: Icon(Icons.confirmation_number), label: 'クーポン'),
          NavigationDestination(icon: Icon(Icons.map), label: '地図'),
        ],
      ),
    );
  }
}
