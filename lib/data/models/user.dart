import 'package:flutter/foundation.dart';
import 'package:ika/domain/entities/user.dart';

class UserModel extends User {
  UserModel({@required String address}) : super(address: address);

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(address: json['address']);
  }

  Map<String, dynamic> toJson() {
    return {'address': address};
  }
}
