import 'package:flutter/material.dart';

class Spot {
  final String id;
  final String name;
  final String category;
  final String coupon;
  final String qrValue;

  const Spot({
    required this.id,
    required this.name,
    required this.category,
    required this.coupon,
    required this.qrValue,
  });
}

class Rank {
  final String key;
  final String label;
  final Color color;
  final double minKm;

  const Rank({
    required this.key,
    required this.label,
    required this.color,
    required this.minKm,
  });
}

// 仮データ：実際のスポット・クイズ内容は枚方信用金庫様・協力店との
// 打ち合わせを踏まえて Firestore 側に置き換える（Week 1-2 で確定）
const List<Spot> spots = [
  Spot(id: 'spot1', name: '枚方涼氷', category: 'かき氷', coupon: '練乳シングルをサービス', qrValue: 'gojushichi:spot1'),
  Spot(id: 'spot2', name: 'KAORU COFFEE', category: 'カフェ', coupon: 'ドリンク10%引き', qrValue: 'gojushichi:spot2'),
  Spot(id: 'spot3', name: '呼人堂', category: 'どら焼き', coupon: '1,500円以上で1個増量', qrValue: 'gojushichi:spot3'),
  Spot(id: 'spot4', name: 'うつわとカフェ Lau', category: 'カフェ', coupon: 'お会計より100円引き', qrValue: 'gojushichi:spot4'),
  Spot(id: 'spot5', name: 'くらわんか餅巴堂', category: '餅菓子', coupon: '500円以上でやきもち1個', qrValue: 'gojushichi:spot5'),
];

// 実際の協力店QRもこの形式（gojushichi:スポットID）で発行する想定。
Spot? findSpotByQrValue(String value) {
  try {
    return spots.firstWhere((s) => s.qrValue == value);
  } catch (_) {
    return null;
  }
}

// 位（ランク）の段階。歩いた距離(km)の累計で判定する
const List<Rank> ranks = [
  Rank(key: 'tabibito', label: '旅人', color: Color(0xFFB08D57), minKm: 0),
  Rank(key: 'hikyaku', label: '飛脚', color: Color(0xFF8C8C8C), minKm: 110),
  Rank(key: 'tonya', label: '問屋', color: Color(0xFFC9A227), minKm: 220),
  Rank(key: 'honjin', label: '本陣', color: Color(0xFFC9A227), minKm: 330),
  Rank(key: 'daimyo', label: '大名行列', color: Color(0xFFD4AF37), minKm: 440),
];

class AppState extends ChangeNotifier {
  // 下タブの現在位置（0:スタンプ帳 1:QR読取 2:クイズ 3:クーポン 4:地図）
  int currentTabIndex = 0;

  void goToTab(int index) {
    currentTabIndex = index;
    notifyListeners();
  }

  // デモ用の暫定値。実際は Health 連携プラグインから取得した歩数を距離に換算する
  double distanceKm = 42;
  List<String> stampedSpotIds = [];
  List<Spot> obtainedCoupons = [];
  String? lastScannedSpotId;

  Rank get currentRank {
    Rank current = ranks.first;
    for (final r in ranks) {
      if (distanceKm >= r.minKm) current = r;
    }
    return current;
  }

  double get rankProgress => (distanceKm / 550 * 100).clamp(0, 100);

  void addDemoDistance(double km) {
    distanceKm = ((distanceKm + km) * 10).round() / 10;
    if (distanceKm > 550) distanceKm = 550;
    notifyListeners();
  }

  void stampSpot(String spotId) {
    if (!stampedSpotIds.contains(spotId)) {
      stampedSpotIds.add(spotId);
      notifyListeners();
    }
  }

  void setLastScannedSpotId(String spotId) {
    lastScannedSpotId = spotId;
    notifyListeners();
  }

  void obtainCoupon(String spotId) {
    final spot = spots.where((s) => s.id == spotId).firstOrNull;
    if (spot != null && !obtainedCoupons.any((c) => c.id == spotId)) {
      obtainedCoupons.add(spot);
      notifyListeners();
    }
  }
}
