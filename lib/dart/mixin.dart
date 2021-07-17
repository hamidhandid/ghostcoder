part of '../dart.dart';

class Mixin extends Container {
  Mixin({
    this.name,
    this.generics = const [],
    this.selfMethods = const [],
    this.dependency,
  });

  @override
  final String? name;

  @override
  final List<Type> generics;

  @override
  final List<Method> selfMethods;

  final Dependency? dependency;

  Type get type => Type(name, dependency: dependency);

  @override
  List<Method> get inheritedMethods => [];

  @override
  List<Dependency?> get dependencies => [
    ...generics,
    ...selfMethods,
  ].dependencies;

  @override
  // TODO: implement render
  String get render => throw UnimplementedError();
}

extension MixinList on List<Mixin> {
  String get render => isEmpty ? '' : 'with ${map((e) => '${e.name}${e.generics.render}').join(', ')} ';
}
