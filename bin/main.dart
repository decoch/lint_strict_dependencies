import 'dart:io';

import 'package:lint_strict_dependencies/file_linter.dart';
import 'package:lint_strict_dependencies/line_linter.dart';
import 'package:lint_strict_dependencies/lint_config.dart';
import 'package:lint_strict_dependencies/lint_error.dart';
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
  stdout.writeln('config targets: ${config.targetDirectories}');
  config.directoryConfigs.forEach((c) {
    stdout.writeln('config directory: ${c.directory}');
    stdout.writeln('config allowedDirectories: ${c.allowedDirectories}');
    stdout.writeln('config allowedSameDirectory: ${c.allowedSameDirectory}');
  });

  final errors = [];
  final files = listFiles(config, currentPath);

  final linter = FileLinter(
    lineLinter: LineLinter(
      config: config,
      packageName: packageName,
    ),
  );
  files.forEach((file) {
    stdout.writeln('lint file: ${file.path}');
    try {
      linter.lint(file);
    } on LintError catch (err) {
      errors.add(err);
    }
  });

  if (errors.isNotEmpty) {
    errors.forEach((err) {
      stderr.writeln('error in file: ${err.filePath}, import: ${err.import}');
    });
    throw Error();
  }

  stopwatch.stop();
  stdout.write(
    '┗━━ success Sorted ${files.length} files in ${stopwatch.elapsed.inSeconds}.${stopwatch.elapsedMilliseconds} seconds\n',
  );
}
