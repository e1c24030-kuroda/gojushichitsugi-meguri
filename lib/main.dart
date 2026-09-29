import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/app_state.dart';
import 'screens/root_screen.dart';
import 'theme.dart';

void main() {
  runApp(const GojushichitsugiApp());
}

class GojushichitsugiApp extends StatelessWidget {
  const GojushichitsugiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(),
      child: MaterialApp(
        title: '五十七次めぐり',
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        home: const RootScreen(),
      ),
    );
  }
}
