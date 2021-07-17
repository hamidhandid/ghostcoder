part of '../dart.dart';

abstract class SetterConfig {}

class MutableSetterConfig extends SetterConfig {}

class ImmutableSetterConfig extends SetterConfig {
  ImmutableSetterConfig(
    this.constructorName,
    [this.values]
  ): assert(constructorName != null && constructorName.isNotEmpty);

  ImmutableSetterConfig.unnamedConstructor([this.values]): constructorName = null;

  final String? constructorName;

  final Map<String, Expression>? values;

  bool get hasUnnamedConstructor => constructorName == null;

  bool get hasNamedConstructor => constructorName != null;
}
