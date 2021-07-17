part of '../dart.dart';

class Parameter extends Code with OptionalCheckers {
  Parameter({
    required this.type,
    String? name,
    this.named = true,
    this.document,
    this.optional,
  }) : name = name ?? type.value!.camelCase;

  final String name;

  final Type type;

  final bool named;

  final Document? document;

  @override
  final Optional? optional;

  bool get isNamed => named == true;

  bool get isPositional => named == false;

  @override
  List<Dependency?> get dependencies => [
    type,
    document,
  ].dependencies.plus(isRequired ? [Dependency('package:meta/meta.dart')] : []);

  @override
  String get render => (
    (isNamed && isRequired ? nullSafe ? 'required ' : '@required ' : '') +
    '$type $name' +
    (isRequired ? '' : optional!.hasDefaultValue ? ' = ${optional!.defaultValue}' : '')
  );
}

extension ParameterList on List<Parameter> {
  bool has(String name) => get(name) != null;

  Parameter? get(String name) => firstWhereOrNull((e) => name == e.name);

  bool get assertion => namedParameters.isEmpty || optionalPositionalParameters.isEmpty;

  List<Parameter> get namedParameters => where((e) => e.isNamed).toList();

  List<Parameter> get positionalParameters => where((e) => e.isPositional).toList();

  List<Parameter> get requiredPositionalParameters => positionalParameters.where((e) => e.isRequired).toList();

  List<Parameter> get optionalPositionalParameters => positionalParameters.where((e) => e.isOptional).toList();

  String get render {
    if (!assertion) {
      throw AssertionError('named and optional positional parameters can not be used together');
    }
    return [
      ...(requiredPositionalParameters.isEmpty ? [] : [requiredPositionalParameters.join(', ')]),
      ...(optionalPositionalParameters.isEmpty ? [] : ['[${optionalPositionalParameters.join(', ')}]']),
      ...(namedParameters.isEmpty ? [] : ['{${namedParameters.join(', ')}}']),
    ].join(', ');
  }

  String invoke(Map<String, Expression> values) {
    final missedRequiredValues = requiredPositionalParameters.where((e) => !values.containsKey(e.name));
    if (missedRequiredValues.isNotEmpty) {
      throw ArgumentError('${missedRequiredValues.map((p) => p.name).join(', ')} not found');
    }
    final nonSenseValues = values.keys.where((v) => firstWhereOrNull((p) => p.name == v) == null);
    if (nonSenseValues.isNotEmpty) {
      throw ArgumentError('${nonSenseValues.join(', ')} ${nonSenseValues.length > 1 ? 'are' : 'is'} non sense');
    }
    final requiredPositionalValues = requiredPositionalParameters
      .map((e) => values[e.name]);
    final optionalPositionalValues = optionalPositionalParameters
      .where((e) => values.containsKey(e.name))
      .map((e) => values[e.name]);
    final namedValues = namedParameters
      .where((e) => values.containsKey(e.name))
      .map((e) => MapEntry(e.name, values[e.name]));
    return [
      ...(requiredPositionalValues.isEmpty ? [] : [requiredPositionalValues.join(', ')]),
      ...(optionalPositionalValues.isEmpty ? [] : [optionalPositionalValues.join(', ')]),
      ...(namedValues.isEmpty ? [] : [namedValues.map((e) => '${e.key}: ${e.value}').join(', ')]),
    ].join(', ');
  }
}
