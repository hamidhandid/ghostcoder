part of '../dart.dart';

class GetterMethodSignature extends MethodSignature {
  GetterMethodSignature({
    required Type output,
    String? name,
  }): super(
      name: name,
      output: output,
      parameters: [],
    );

  @override
  String get render => '$output get $name';
}
