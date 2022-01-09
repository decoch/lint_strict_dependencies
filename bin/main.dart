import 'dart:io';

import 'package:lint_strict_dependencies/lint_config.dart';
import 'package:lint_strict_dependencies/lint_file.dart';
import 'package:lint_strict_dependencies/list_files.dart';
import 'package:yaml/yaml.dart';

void main(List<String> args) {
  final currentPath = Directory.current.path;

  final pubspecYamlFile = File('${currentPath}/pubspec.yaml');
  final pubspecYaml = loadYaml(pubspecYamlFile.readAsStringSync());

  final packageName = pubspecYaml['name'];
  final dependencies = [];

  final stopwatch = Stopwatch();
  stopwatch.start();

  final pubspecLockFile = File('${currentPath}/pubspec.lock');
  final pubspecLock = loadYaml(pubspecLockFile.readAsStringSync());
  dependencies.addAll(pubspecLock['packages'].keys);

  final configYamlFile = File('${currentPath}/strict_dependencies.yaml');
  final configYaml = loadYaml(configYamlFile.readAsStringSync());

  // Reading from config in pubspec.yaml safely
  if (!configYaml.containsKey('rules')) {
    throw StateError('rules is not exists');
  }

  final rules = configYaml['rules'];
  final directoryConfigs = (rules as List).map((e) {
    return LintDirectoryConfig(
      e['module'] as String,
      (e['allowReferenceFrom'] as List).map((e) => e as String).toList(),
      e['allowSameModule'] as bool,
    );
  }).toList();
  final config = LintConfig(['lib'], directoryConfigs);
  stdout.writeln('config');
  stdout.writeln('config targets: ${config.targetDirectories}');
  config.directoryConfigs.forEach((c) {
    stdout.writeln('config directory: ${c.directory}');
    stdout.writeln('config allowedDirectories: ${c.allowedDirectories}');
    stdout.writeln('config allowedSameDirectory: ${c.allowedSameDirectory}');
  });

  final errors = [];
  final files = listFiles(config, currentPath);
  files.forEach((file) {
    stdout.writeln('lint file: ${file.path}');
    final error = lintFile(config, packageName, file);
    if (error != null) {
      stderr.writeln('file: ${error.file}, invalid: ${error.invalidImport}');
      errors.add(error);
    }
  });

  if (errors.isNotEmpty) {
    throw StateError('message');
  }
}
