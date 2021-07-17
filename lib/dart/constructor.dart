part of '../dart.dart';

class Constructor extends Callable {
  Constructor({
    ConstructorSignature? signature,
    this.preBodies = const [],
    this.body,
    this.document,
    this.isConst = false,
  }): signature = signature ?? ConstructorSignature.unnamed();

  final ConstructorSignature signature;

  final List<PreBody> preBodies;

  final Body? body;

  final Document? document;

  final bool isConst;

  bool get isRenderable => (
    signature.parameters.isNotEmpty ||
    preBodies.isNotEmpty ||
    body != null
  );

  @override
  List<Dependency?> get dependencies => [
    signature,
    body,
    document,
    ...preBodies,
  ].dependencies;

  @override
  String get render => '${document ?? ''}${isConst ? 'const ': ''}$signature${preBodies.render}${body ?? ';'}';

  Expression call({
    Map<String, Expression>? values,
    List<Type> generics = const [],
  }) {
    final _values = values ?? Map.fromEntries(signature.parameters.map((e) => MapEntry(e.name, Expression('e.name'))));
    return Expression(
      '${isConst ? 'const ' : ''}${signature.output}${signature.isDefault ? '' : '.${signature.name}'}${generics.render}(${signature.parameters.invoke(_values)})',
      dependencies: dependencies,
    );
  }

  Redirect getSelfRedirect({
    Map<String, Expression>? values,
    List<Type>? generics,
  }) => Redirect._(
    values: values,
    generics: generics,
    prefix: 'this',
    constructor: this,
  );

  Redirect getChildRedirect({
    Map<String, Expression>? values,
    List<Type>? generics,
  }) => Redirect._(
    values: values,
    generics: generics,
    prefix: 'super',
    constructor: this,
  );

  Constructor setSignature(ConstructorSignature signature) => Constructor(
    body: body,
    document: document,
    preBodies: preBodies,
    signature: signature,
  );

  Constructor setPreBodies(List<PreBody> preBodies) => Constructor(
    body: body,
    document: document,
    preBodies: preBodies,
    signature: signature,
  );
}

extension ConstructorList on List<Constructor> {
  bool has([String? name]) => get(name) != null;

  bool get hasUnnamed => hasDefault;

  bool get hasDefault => unnamed != null;

  Constructor? get unnamed => get();

  Constructor? get([String? name]) => firstWhereOrNull(
    (e) => name == null ? e.signature.isDefault : e.signature.name == name,
  );

  String get render => where((e) => e.isRenderable).join('$LINE_SEPARATOR$LINE_SEPARATOR');
}
