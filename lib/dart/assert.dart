part of '../dart.dart';

class Assert extends PreBody {
  Assert({
    required this.expression,
  }): assert(expression != null);

  final Expression expression;

  @override
  List<Dependency?>? get dependencies => expression.dependencies;

  @override
  String get render => 'assert($expression)';
}
