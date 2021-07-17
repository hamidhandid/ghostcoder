part of '../dart.dart';

class PartFile extends AFile {
  PartFile({
    required this.path,
    required this.containerPath,
    this.codes = const [],
    this.format = const Format(),
  }): assert(path != null)
    , assert(containerPath != null);

  final List<Code> codes;

  final String path;

  final String containerPath;

  final Format format;

  String get name => path.split('/').last;

  @override
  List<Dependency?> get dependencies => codes.dependencies;

  @override
  String get render => format._run('''part of '$containerPath';

${codes.render}
''');

  PartFile setCodes(List<Code> codes) => PartFile(
    containerPath: containerPath,
    path: path,
    codes: codes,
    format: format,
  );
}

extension PartFileList on List<PartFile> {
  String get render => isEmpty
    ? ''
    : map((e) => "part '${e.path}';").join('$LINE_SEPARATOR') + LINE_SEPARATOR + LINE_SEPARATOR;
}
