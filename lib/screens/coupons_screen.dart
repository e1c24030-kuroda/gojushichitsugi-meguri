import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../theme.dart';

class CouponsScreen extends StatelessWidget {
  const CouponsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text('獲得クーポン', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.ink)),
            const SizedBox(height: 4),
            const Text('クイズに正解してもらったクーポンの一覧です。お店でこの画面を見せてください。',
                style: TextStyle(color: AppColors.inkSoft)),
            const SizedBox(height: 20),

            if (appState.obtainedCoupons.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: Text('まだクーポンがありません。QRを読み取ってクイズに正解すると、ここに増えていきます。',
                    textAlign: TextAlign.center, style: TextStyle(color: AppColors.inkSoft)),
              )
            else
              ...appState.obtainedCoupons.map((coupon) => Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border(left: BorderSide(color: AppColors.gold, width: 4)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(coupon.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                        Text(coupon.coupon, style: const TextStyle(color: AppColors.indigo, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  )),
          ],
        ),
      ),
    );
  }
}
