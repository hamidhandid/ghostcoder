part of '../dart.dart';

class Property extends Code with ContainerMixin {
  Property({
    required this.type,
    String? name,
    this.isFinal = true,
    this.isStatic = false,
    this.setterConfig,
    this.hasGetter = false,
    this.document,
    this.value,
    this.isConst = false,
  })  : name = name ?? type.value!.camelCase,
        assert(setterConfig == null ||
            (isFinal ? setterConfig is ImmutableSetterConfig : setterConfig is MutableSetterConfig));

  final String name;

  final Type type;

  final bool isFinal;

  final bool isConst;

  final bool isStatic;

  final bool hasGetter;

  final SetterConfig? setterConfig;

  final Document? document;

  final Expression? value;

  bool get hasSetter => setterConfig != null;

  Class? get _class => __container as Class?;

  Method get getter {
    return Method(
      signature: GetterMethodSignature(
        output: type,
        name: name.replaceAll('_', ''),
      ),
      body: Body.expression(Expression(name)),
      isStatic: isStatic,
    )..signature._container = _class;
  }

  Method get setter {
    final parameter = Parameter(
      type: type,
      name: name.replaceAll('_', ''),
      named: false,
    );
    return Method(
      signature: MethodSignature(
        name: 'set${parameter.name.pascalCase}',
        output: isFinal ? _class!.type : null,
        parameters: [parameter],
      ),
      body: setterConfig is ImmutableSetterConfig
          ? Body.expression(
              _class!.constructors.get(
                (setterConfig as ImmutableSetterConfig).constructorName,
              )!(values: (setterConfig as ImmutableSetterConfig).values),
            )
          : Body.block(content: '${name} = ${parameter.name};'),
      isStatic: isStatic,
    )..signature._container = _class;
  }

  bool get isPrivate => name.startsWith('_');

  @override
  List<Dependency?> get dependencies => [
        type,
        document,
      ].dependencies;

  @override
  String get render =>
      '${document ?? ''}${isStatic ? 'static ' : ''}${isConst ? 'const ' : ''}${isFinal ? 'final ' : ''}$type $name${value == null ? '' : ' = $value'};';
}

extension PropertyList on List<Property> {
  bool has(String name) => get(name) != null;

  Property? get(String name) => firstWhereOrNull((e) => e.name == name);

  List<Method?> get getters => where((e) => e.hasGetter).map((e) => e.getter) as List<Method?>;

  List<Method?> get setters => where((e) => e.hasSetter).map((e) => e.setter) as List<Method?>;

  String get render => join('$LINE_SEPARATOR$LINE_SEPARATOR');
}
