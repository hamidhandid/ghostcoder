part of '../dart.dart';

class Func extends Callable {
  Func({
    required this.signature,
    Body? body,
    this.document,
    this.async,
    this.dependency,
  }): body = body ?? Body.expression();

  final Signature signature;

  final Body body;

  final Document? document;

  final Async? async;

  final Dependency? dependency;

  @override
  List<Dependency?> get dependencies => [
    signature,
    document,
    body,
  ].dependencies.plus([dependency]);

  @override
  String get render => '${document ?? ''}$signature${async == null ? '' : '$async'}$body';

  Expression call({
    required Map<String, Expression> values,
    List<Type>? generics,
  }) =>
      Expression(
        '${signature.name}${generics?.render}(${signature.parameters.invoke(values)})',
        dependencies: dependencies,
      );
}
