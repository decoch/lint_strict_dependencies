import 'dart:io';

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
  if (configYaml.containsKey('rules')) {
    final config = configYaml['rules'];
    print(packageName);
    print(config);
    print(currentPath);
  }
}
