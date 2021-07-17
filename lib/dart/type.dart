part of '../dart.dart';

class Type extends Code {
  Type(this.value, {
    this.generics = const [],
    this.dependency,
  });

  final String? value;

  final List<Type> generics;

  final Dependency? dependency;

  @override
  List<Dependency?> get dependencies => generics.dependencies.plus([dependency]);

  @override
  String get render => '${value}${generics.render}';
}

extension TypeList on List<Type> {
  String get render => isEmpty ? '' : '<${join(', ')}>';
}
