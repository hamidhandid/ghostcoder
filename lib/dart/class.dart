part of '../dart.dart';

class Class extends Container {
  Class({
    bool? isImmutable,
    this.isAbstract = false,
    required this.name,
    this.generics = const [],
    this.parent,
    this.interfaces = const [],
    this.mixins = const [],
    List<Constructor> constructors = const [],
    this.properties = const [],
    this.selfMethods = const [],
    this.dependency,
  }): assert(interfaces.where((e) => !isAbstract).isEmpty)
    , constructors = constructors.isEmpty ? [Constructor()] : constructors
    , isImmutable = isImmutable ?? properties.where((e) => !e.isFinal).isEmpty && (parent?.hierarchy.where((e) => e.isImmutable).isEmpty ?? true) {
    for (var constructor in this.constructors) {
      constructor.signature._container = this;
    }
    for (var property in properties) {
      property._container = this;
    }
    for (var method in selfMethods) {
      method.signature._container = this;
    }
  }

  @override
  final String name;

  @override
  final List<Type> generics;

  final bool isAbstract;

  final bool isImmutable;

  final Class? parent;

  final List<Class> interfaces;

  final List<Mixin> mixins;

  final List<Constructor> constructors;

  final List<Property> properties;

  @override
  final List<Method> selfMethods;

  final Dependency? dependency;

  Type get type => Type(name, dependency: dependency);

  Type get nullableType => Type('${type.value}?', dependency: type.dependency);

  List<Class> get hierarchy => [this, ...(parent?.hierarchy ?? [])];

  bool isChildOf(Class another) => hasParent && another.name == parent!.name;

  bool get hasParent => parent != null;

  @override
  List<Method> get inheritedMethods => [
    ...(hasParent ? parent!.methods : []),
    ...interfaces.fold([], (res, e) => [...res, ...e.methods]),
    ...mixins.fold([], (res, e) => [...res, ...e.methods]),
  ];

  @override
  List<Dependency?> get dependencies => [
    ...generics,
    ...constructors,
    ...properties,
    ...selfMethods,
  ].dependencies.plus([
    parent?.dependency,
    ...interfaces.fold([], (res, e) => [...res, e.dependency]),
    ...mixins.fold([], (res, e) => [...res, e.dependency]),
    ...isImmutable ? [Dependency('package:meta/meta.dart')] : [],
  ]);

  @override
  String get render => '''${isImmutable ? '@immutable$LINE_SEPARATOR' : ''}${isAbstract ? 'abstract ' : ''}class $name${generics.render} ${hasParent ? 'extends ${parent!.name}${parent!.generics.render} ' : ''}${mixins.render}${interfaces.render}{
  ${constructors.render}

  ${properties.render}

  ${selfMethods.render}

  ${properties.where((e) => e.hasGetter).map((e) => e.getter).toList().render}

  ${properties.where((e) => e.hasSetter).map((e) => e.setter).toList().render}
}
''';

  Class setConstructors(List<Constructor> constructors) => Class(
    dependency: dependency,
    name: name,
    generics: generics,
    isAbstract: isAbstract,
    isImmutable: isImmutable,
    parent: parent,
    interfaces: interfaces,
    mixins: mixins,
    constructors: constructors,
    properties: properties,
    selfMethods: selfMethods,
  );

  Class setGenerics(List<Type> generics) => Class(
    dependency: dependency,
    name: name,
    generics: generics,
    isAbstract: isAbstract,
    isImmutable: isImmutable,
    parent: parent,
    interfaces: interfaces,
    mixins: mixins,
    constructors: constructors,
    properties: properties,
    selfMethods: selfMethods,
  );

  Class setProperties(List<Property> properties) => Class(
    dependency: dependency,
    name: name,
    generics: generics,
    isAbstract: isAbstract,
    isImmutable: isImmutable,
    parent: parent,
    interfaces: interfaces,
    mixins: mixins,
    constructors: constructors,
    properties: properties,
    selfMethods: selfMethods,
  );

  Class update(Class Function(Class self) cb) => cb(this);

  Class setSelfMethods(List<Method> selfMethods) => Class(
    dependency: dependency,
    name: name,
    generics: generics,
    isAbstract: isAbstract,
    isImmutable: isImmutable,
    parent: parent,
    interfaces: interfaces,
    mixins: mixins,
    constructors: constructors,
    properties: properties,
    selfMethods: selfMethods,
  );

  Class setDependency(Dependency dependency) => Class(
    dependency: dependency,
    name: name,
    generics: generics,
    isAbstract: isAbstract,
    isImmutable: isImmutable,
    parent: parent,
    interfaces: interfaces,
    mixins: mixins,
    constructors: constructors,
    properties: properties,
    selfMethods: selfMethods,
  );
}

extension InterfaceList on List<Class> {
  String get render => isEmpty ? '' : 'implements ${map((e) => '${e.name}${e.generics.render}').join(', ')} ';
}
