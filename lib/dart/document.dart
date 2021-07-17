part of '../dart.dart';

class Document extends Code {
  Document(this.description);

  final String description;

  @override
  List<Dependency> get dependencies => [];

  @override
  String get render => description.split(LINE_SEPARATOR).map((e) => '/// $e').join(LINE_SEPARATOR);
}
