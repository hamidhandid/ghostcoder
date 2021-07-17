part of '../dart.dart';

class ConstructorSignature extends Signature with ContainerMixin {
  ConstructorSignature({
    required String? name,
    List<Type>? generics,
    this.parameters = const [],
  }): assert(name != null && name != '')
    , super(
      name: name,
      generics: generics,
    );

  ConstructorSignature.unnamed({
    List<Type>? generics,
    this.parameters = const [],
  }): super(
      name: null,
      generics: generics,
    );

  @override
  final List<ConstructorParameter> parameters;

  bool get isDefault => name == null;

  Class? get _class => __container as Class?;

  @override
  Type get output => Type(_class!.name);

  @override
  List<Dependency?> get dependencies => super.dependencies.plus(parameters.dependencies);

  @override
  String get render => '$output${isDefault ? '' : '.$name'}${generics!= null ? generics!.render : ""}(${parameters.render})';

  ConstructorSignature setParameters(List<ConstructorParameter> parameters) => ConstructorSignature(
    name: name,
    generics: generics,
    parameters: parameters,
  );
}
