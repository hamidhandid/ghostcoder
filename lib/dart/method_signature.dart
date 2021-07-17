part of '../dart.dart';

class MethodSignature extends Signature with ContainerMixin {
  MethodSignature({
    required String? name,
    Type? output,
    List<Type>? generics,
    required List<Parameter> parameters,
  }): super(
      name: name,
      output: output,
      generics: generics,
      parameters: parameters,
    );

  Class? get _class => __container as Class?;

  MethodSignature setOutput(Type output) => MethodSignature(
    name: name,
    generics: generics,
    output: output,
    parameters: parameters,
  );
}
