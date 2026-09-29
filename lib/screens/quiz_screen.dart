import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../theme.dart';

// 仮のクイズ。実際は地点ごとに「次の地点の周辺」をヒントにした問題をFirestoreに登録する
const question = '次の地点に向かう途中、甘い香りがするお店は何のお店？';
const options = ['どら焼き屋', '本屋', '床屋'];
const correctAnswer = 'どら焼き屋';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  bool answered = false;
  bool isCorrect = false;

  void _answer(String choice) {
    setState(() {
      answered = true;
      isCorrect = choice == correctAnswer;
    });
  }

  void _pickCoupon(String spotId) {
    final appState = context.read<AppState>();
    appState.obtainCoupon(spotId);
    appState.goToTab(3);
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final scannedSpot = spots.where((s) => s.id == appState.lastScannedSpotId).firstOrNull;

    final candidateSpots = spots
        .where((s) => s.id != appState.lastScannedSpotId && !appState.obtainedCoupons.any((c) => c.id == s.id))
        .toList();

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text('クイズ', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.ink)),
            const SizedBox(height: 16),

            if (scannedSpot == null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.line),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('まだQRを読み取っていません。先に「QR読取」からスタンプを獲得してください。'),
                    const SizedBox(height: 14),
                    FilledButton(
                      onPressed: () => appState.goToTab(1),
                      child: const Text('QR読取へ'),
                    ),
                  ],
                ),
              )
            else ...[
              Text('${scannedSpot.name}でスタンプ獲得！ 続けてクイズに挑戦しよう。',
                  style: const TextStyle(color: AppColors.inkSoft)),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.line),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(question, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 12),
                    ...options.map((opt) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: answered ? null : () => _answer(opt),
                              child: Text(opt),
                            ),
                          ),
                        )),
                  ],
                ),
              ),
              if (answered) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.line),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(isCorrect
                          ? '🎉 正解！ 次の地点周辺のお店から1店を選んでクーポンを獲得しよう。'
                          : '残念、不正解でした。でもスタンプは獲得済み。次のスポットに進もう。'),
                      const SizedBox(height: 10),
                      if (isCorrect)
                        ...candidateSpots.map((spot) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: SizedBox(
                                width: double.infinity,
                                child: FilledButton(
                                  onPressed: () => _pickCoupon(spot.id),
                                  child: Text('${spot.name}（${spot.coupon}）'),
                                ),
                              ),
                            ))
                      else
                        OutlinedButton(
                          onPressed: () => appState.goToTab(0),
                          child: const Text('スタンプ帳に戻る'),
                        ),
                    ],
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
