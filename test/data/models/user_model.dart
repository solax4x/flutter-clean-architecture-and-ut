import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:ika/data/models/user.dart';
import 'package:ika/domain/entities/user.dart';

import '../../fixtures/fixture_reader.dart';

void main() {
  final tUserModel = UserModel(address: 'test@gmail.com');

  test('Userエンティティの子クラスであること', () async {
    expect(tUserModel, isA<User>());
  });

  group('fromJson', () {
    test('json形式のUserModelからオブジェクト生成出来ること', () async {
      final Map<String, dynamic> jsonMap = json.decode(fixture('user.json'));
      final result = UserModel.fromJson(jsonMap);
      expect(result, tUserModel);
    });
  });

  group('toJson', () {
    test('UserModelをjson変換出来ること', () async {
      final result = tUserModel.toJson();
      expect(result, {"address": "test@gmail.com"});
    });
  });
}
