part of '../dart.dart';

class Body extends Code {
  Body._({
    required this.block,
    String? content,
    this.dependencies = const [],
  }): content = content ?? 'throw UnimplementedError()' + (block ? ';$LINE_SEPARATOR' : '');

  factory Body.block({ String? content, List<Dependency>? dependencies }) => Body._(
    block: true,
    content: content,
    dependencies: dependencies,
  );

  factory Body.expression([Expression? expression]) => Body._(
    block: false,
    content: expression?.toString(),
    dependencies: expression?.dependencies,
  );

  final String content;

  final bool block;

  bool get isBlock => block == true;

  bool get isExpression => block == false;

  @override
  final List<Dependency?>? dependencies;

  @override
  String get render => isExpression ? ' => $content;' : ''' {
  $content
}''';

  Body setContent(String content) => Body._(
    content: content,
    block: block,
    dependencies: dependencies,
  );
}
