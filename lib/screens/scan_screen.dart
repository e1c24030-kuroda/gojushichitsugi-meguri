import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../theme.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  bool cameraOn = false;
  String errorMsg = '';
  bool handled = false;

  void _startCamera() {
    setState(() {
      cameraOn = true;
      errorMsg = '';
      handled = false;
    });
  }

  void _stopCamera() {
    setState(() => cameraOn = false);
  }

  void _handleDecoded(String value) {
    if (handled) return;
    final spot = findSpotByQrValue(value);
    setState(() => handled = true);
    _stopCamera();
    if (spot == null) {
      setState(() => errorMsg = 'このQRコードは登録されているスポットのものではありません（読み取った内容: $value）');
      return;
    }
    _simulateScan(spot.id);
  }

  void _simulateScan(String spotId) {
    final appState = context.read<AppState>();
    appState.stampSpot(spotId);
    appState.setLastScannedSpotId(spotId);
    appState.goToTab(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text('QR読取', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.ink)),
            const SizedBox(height: 4),
            const Text('協力店に設置されたQRコードを読み取ると、その場でスタンプがもらえます。',
                style: TextStyle(color: AppColors.inkSoft)),
            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.line),
              ),
              child: Column(
                children: [
                  if (cameraOn)
                    SizedBox(
                      height: 320,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: MobileScanner(
                          onDetect: (capture) {
                            final barcodes = capture.barcodes;
                            if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
                              _handleDecoded(barcodes.first.rawValue!);
                            }
                          },
                        ),
                      ),
                    ),
                  const SizedBox(height: 12),
                  if (!cameraOn) ...[
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _startCamera,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 14),
                          child: Text('カメラでQRを読み取る'),
                        ),
                      ),
                    ),
                    if (errorMsg.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(errorMsg, style: const TextStyle(color: Color(0xFFB23A2E), fontSize: 13)),
                      ),
                  ] else
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: _stopCamera,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 14),
                          child: Text('カメラを止める'),
                        ),
                      ),
                    ),
                ],
              ),
            ),

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
                  const Text('またはお店を選ぶ（手動・デモ用）', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                  const SizedBox(height: 10),
                  ...spots.map((spot) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () => _simulateScan(spot.id),
                            child: Text('${spot.name}（${spot.category}）のQRを読む'),
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
