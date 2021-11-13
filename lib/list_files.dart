import 'dart:io';

import 'package:lint_strict_dependencies/file_entity.dart';

List<FileEntity> dartFiles(String currentPath, List<String> args) {
  final dartFiles = <FileEntity>[];
  final targetFileSystemEntities = [
    ..._readDir(currentPath, 'lib'),
    ..._readDir(currentPath, 'bin'),
    ..._readDir(currentPath, 'test'),
    ..._readDir(currentPath, 'tests'),
    ..._readDir(currentPath, 'test_driver'),
    ..._readDir(currentPath, 'integration_test'),
  ];

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
