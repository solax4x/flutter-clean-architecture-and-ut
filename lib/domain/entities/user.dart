import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class User extends Equatable {
  final String address;

  User({@required this.address});

  @override
  List<Object> get props => [address];
}
