part of '../dart.dart';

class Async with Renderable {
  Async({this.generator = false});

  final bool generator;

  @override
  String get render => ' async${generator ? '*' : ''}';
}
