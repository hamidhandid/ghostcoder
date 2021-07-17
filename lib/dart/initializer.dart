part of '../dart.dart';

class Initializer extends PreBody {
  Initializer({
    required this.target,
    required this.expression,
  }): assert(target != null)
    , assert(expression != null);

  final Property target;

  final Expression expression;

  @override
  List<Dependency?> get dependencies => [
    target,
    expression,
  ].dependencies;

  @override
  String get render => '${target.name} = $expression';
}
