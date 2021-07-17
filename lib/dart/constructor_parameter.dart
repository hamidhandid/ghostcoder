part of '../dart.dart';

class ConstructorParameter extends Parameter {
  ConstructorParameter({
    required Type type,
    String? name,
    bool named = true,
    Document? document,
    Optional? optional,
    this.sugar = true,
  }): super(
      type: type,
      name: name,
      named: named,
      document: document,
      optional: optional,
    );

  final bool sugar;

  @override
  String get render => sugar ? super.render.replaceFirst('$type $name', 'this.$name') : super.render;

  ConstructorParameter setSugar(bool sugar) => ConstructorParameter(
    type: type,
    document: document,
    name: name,
    named: named,
    optional: optional,
    sugar: sugar,
  );
}
