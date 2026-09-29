// スタンプ帳（ホーム）画面が、アプリ起動時にちゃんと表示されるかの基本テスト

import 'package:flutter_test/flutter_test.dart';

import 'package:gojushichitsugi_meguri/main.dart';

void main() {
  testWidgets('起動するとスタンプ帳画面が表示される', (WidgetTester tester) async {
    await tester.pumpWidget(const GojushichitsugiApp());

    expect(find.text('五十七次めぐり'), findsOneWidget);
    expect(find.text('スタンプ帳（0 / 5）'), findsOneWidget);
  });
}
