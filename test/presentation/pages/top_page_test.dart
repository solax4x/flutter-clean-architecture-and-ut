import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ika/data/models/user.dart';
import 'package:ika/presentation/pages/top_page.dart';

void main() async {
  group('TOP画面',(){
    final tUser = UserModel(address: 'test@gmail.com');
    testWidgets('ログアウトボタン確認', (WidgetTester tester) async {
      await tester.pumpWidget(MediaQuery(
          data: MediaQueryData(size: Size(375, 812), padding: EdgeInsets.all(20)),
          child: MaterialApp(home: TopPage.create(tUser))));

      final logoutBtn = find.text('ログアウト');
      expect(logoutBtn, findsOneWidget);
      expect(find.byType(FlatButton), findsOneWidget);
    });
  });
}
