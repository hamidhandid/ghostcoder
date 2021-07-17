part of '../dart.dart';

class Method extends Callable {
  Method({
    required this.signature,
    this.body,
    this.document,
    this.isStatic = false,
    this.async,
  }): assert(body != null || !isStatic);

  final MethodSignature signature;

  final Body? body;

  final Document? document;

  final bool isStatic;

  final Async? async;

  bool get isOverride => signature._class!.overrideMethods.has(signature.name);

  bool get isAbstract => body == null;

  @override
  List<Dependency?> get dependencies => [
    signature,
    body,
    document,
  ].dependencies;

  @override
  String get render => (
    '${document != null ? document!.render + LINE_SEPARATOR : ''}' +
    (isOverride ? '@override$LINE_SEPARATOR' : '') +
    '${isStatic ? 'static ' : ''}$signature' +
    (isAbstract ? ';' : '${async == null ? '' : '$async'}$body')
  );

  Expression call({
    Map<String, Expression>? values,
    List<Type>? generics,
  }) =>
      Expression(
        (isStatic ? '${signature._class!.name}.' : '') +
            '${signature.name}${generics?.render}' +
            (signature is GetterMethodSignature ? '' : '(${signature.parameters.invoke(values!)})'),
        dependencies: dependencies,
      );

  Method setSignature(MethodSignature signature) => Method(
    signature: signature,
    async: async,
    body: body,
    document: document,
    isStatic: isStatic,
  );

  Method setBody(Body body) => Method(
    signature: signature,
    async: async,
    body: body,
    document: document,
    isStatic: isStatic,
  );

  Method setAsync(Async async) => Method(
    signature: signature,
    async: async,
    body: body,
    document: document,
    isStatic: isStatic,
  );
}

extension MethodList on List<Method> {
  bool has(String? name) => get(name) != null;

  Method? get(String? name) => firstWhereOrNull((e) => e.signature.name == name);

  String get render => join('$LINE_SEPARATOR$LINE_SEPARATOR');
}
