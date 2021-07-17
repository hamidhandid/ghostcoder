part of '../dart.dart';

class File extends AFile {
  File({
    required this.path,
    this.codes = const [],
    this.parts = const [],
    this.format = const Format(),
  }): assert(path != null);

  final List<Code> codes;

  final String path;

  final List<PartFile> parts;

  final Format format;

  String get name => path.split('/').last;

  @override
  List<Dependency?> get dependencies => <Dependent>[...codes, ...parts].dependencies;

  @override
  String get render => format._run('${dependencies.render}${parts.render}${codes.render}');
}
