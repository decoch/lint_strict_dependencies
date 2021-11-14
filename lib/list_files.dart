import 'dart:io';

import 'package:lint_strict_dependencies/file_entity.dart';
import 'package:lint_strict_dependencies/lint_config.dart';

List<FileEntity> listFiles(
  LintConfig config,
  String currentPath,
  List<String> args,
) {
  final targetFileSystemEntities = config.targetDirectories
      .map((directory) => _readDir(currentPath, directory))
      .expand((files) => files)
      .toList();

  final dartFiles = <FileEntity>[];
  for (final fileOrDirectory in targetFileSystemEntities) {
    if (fileOrDirectory is File && fileOrDirectory.path.endsWith('.dart')) {
      dartFiles.add(FileEntity(fileOrDirectory.path, fileOrDirectory));
    }
  }
  return dartFiles;
}

List<FileSystemEntity> _readDir(String currentPath, String name) {
  if (Directory('$currentPath/$name').existsSync()) {
    return Directory('$currentPath/$name').listSync(recursive: true);
  }
  return [];
}
