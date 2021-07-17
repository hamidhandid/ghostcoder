// import 'package:dart_style/dart_style.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:recase/recase.dart';

part 'dart/assert.dart';
part 'dart/async.dart';
part 'dart/body.dart';
part 'dart/class.dart';
part 'dart/constructor.dart';
part 'dart/constructor_parameter.dart';
part 'dart/constructor_signature.dart';
part 'dart/document.dart';
part 'dart/enum.dart';
part 'dart/expression.dart';
part 'dart/file.dart';
part 'dart/func.dart';
part 'dart/getter_method_signature.dart';
part 'dart/initializer.dart';
part 'dart/method.dart';
part 'dart/method_signature.dart';
part 'dart/mixin.dart';
part 'dart/parameter.dart';
part 'dart/part_file.dart';
part 'dart/property.dart';
part 'dart/redirect.dart';
part 'dart/setter_config.dart';
part 'dart/signature.dart';
part 'dart/type.dart';

bool nullSafe = false;

class Format {
  const Format({
    this.pageWidth = 120,
    this.indent = 2,
  });

  final int pageWidth;
  final int indent;

  String _run(String source) => source;

  // String _run(String source) => DartFormatter(
  //   pageWidth: pageWidth,
  //   indent: indent,
  // ).format(source);
}

const LINE_SEPARATOR = '\n';

abstract class Code with Dependent, Renderable {}

extension CodeList on List<Code> {
  String get render => join('$LINE_SEPARATOR$LINE_SEPARATOR');
}

abstract class AFile with Dependent, Renderable {}

abstract class Callable extends Code implements Function {}

abstract class Container extends Code {
  String? get name;

  List<Type> get generics;

  List<Method> get selfMethods;

  List<Method> get inheritedMethods;

  List<Method> get methods => [
        ...selfMethods,
        ...inheritedMethods,
      ];

  List<Method> get overrideMethods => selfMethods.where((e) => inheritedMethods.has(e.signature.name)).toList();
}

mixin ContainerMixin {
  Container? __container;

  set _container(Container? container) {
    __container = container;
  }
}

abstract class PreBody extends Code {}

extension PreBodyList on List<PreBody> {
  String get render => (isEmpty ? '' : ': ') + join('$LINE_SEPARATOR    , ');
}

mixin Dependent {
  List<Dependency?>? get dependencies;
}

extension DependentList on List<Dependent?> {
  List<Dependency?> get dependencies => where((e) => e != null).fold(
        [],
        (dependencies, dependent) => [
          ...dependencies,
          ...dependent?.dependencies ?? [],
        ],
      );
}

mixin Renderable {
  String get render;

  @override
  String toString() => render;
}

mixin OptionalCheckers {
  Optional? get optional;

  bool get isOptional => optional != null;

  bool get isRequired => optional == null;
}

class Optional {
  Optional([this.defaultValue]);

  final String? defaultValue;

  bool get hasDefaultValue => defaultValue != null;
}

class Dependency with Renderable {
  Dependency(this.path);

  final String path;

  @override
  String get render => "import '$path';";

  @override
  bool operator ==(o) => o is Dependency && path == o.path;

  bool get isDart => path.startsWith('dart:');

  bool get isPackage => path.startsWith('package:');

  bool get isRelative => !isDart && !isPackage;
}

extension DependencyList on List<Dependency?> {
  List<Dependency?> plus(List<Dependency?> list) => [...this, ...list];

  String get render {
    final paths = where((e) => e != null).map((e) => e!.path).toSet().toList()..sort();
    final distinct = paths.map((e) => Dependency(e)).toList();
    return (distinct.where((e) => e.isDart).toList()._render +
        distinct.where((e) => e.isPackage).toList()._render +
        distinct.where((e) => e.isRelative).toList()._render);
  }

  String get _render => isEmpty ? '' : join(LINE_SEPARATOR) + LINE_SEPARATOR + LINE_SEPARATOR;
}
