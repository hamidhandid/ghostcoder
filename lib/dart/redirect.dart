part of '../dart.dart';

class Redirect extends PreBody {
  Redirect._({
    required this.constructor,
    required this.values,
    required this.prefix,
    this.generics = const [],
  });

  final Constructor constructor;

  final Map<String, Expression>? values;

  final String prefix;

  final List<Type>? generics;

  @override
  String get render => constructor(values: values, generics: generics ?? []).render.replaceFirst('${constructor.signature.output}', prefix);

  @override
  List<Dependency?> get dependencies => <Dependent>[
   constructor,
    ...values?.values ?? <Expression>[],
    ...generics ?? [],
  ].dependencies;
}
