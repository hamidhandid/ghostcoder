part of '../dart.dart';

class Signature extends Code {
  Signature({
    required this.name,
    Type? output,
    this.generics = const [],
    this.parameters = const [],
  }): assert(parameters.assertion)
    , output = output ?? Type('void');

  final String? name;

  final Type output;

  final List<Type>? generics;

  final List<Parameter> parameters;

  @override
  List<Dependency?> get dependencies => <Dependent>[
    output,
    ...generics ?? [],
    ...parameters,
  ].dependencies;

  @override
  String get render => '$output $name${generics != null ? generics!.render : ""}(${parameters.render})';
}
