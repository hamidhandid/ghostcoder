part of '../dart.dart';

class Expression extends Code {
  Expression(this.render, {
    this.dependencies
  });

  @override
  final String render;

  @override
  final List<Dependency?>? dependencies;
}
