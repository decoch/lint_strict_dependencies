import 'package:lint_strict_dependencies/file_entity.dart';
import 'package:lint_strict_dependencies/lint_config.dart';
import 'package:lint_strict_dependencies/lint_error.dart';

LintError? lintFile(LintConfig config, String packageName, FileEntity file) {
  final lines = file.readAsLinesSync();
  for (var i = 0; i < lines.length; i++) {
    final line = lines[i];
    if (line.startsWith('import ') && line.endsWith(';')) {
      if (line.contains('package:$packageName/')) {
        final imports = _filterInvalid(config, packageName, file.path, line);
        if (imports.isNotEmpty) {
          return LintError(file.path, imports);
        }
      }
    }
  }
  return null;
}

List<String> _filterInvalid(
  LintConfig config,
  String packageName,
  String path,
  String line,
) {
  if (!line.contains(packageName)) {
    return [];
  }
  return config.directoryConfigs
      .where((c) => line.contains(c.directory))
      .where((c) => !_containsInAllowedSameDirectory(c, path))
      .where((c) => !_containsInAllowedDirectories(c, path))
      .map((_) => path)
      .toList();
}

bool _containsInAllowedSameDirectory(
  LintDirectoryConfig config,
  String path,
) {
  return config.allowedSameDirectory && path.contains(config.directory);
}

bool _containsInAllowedDirectories(LintDirectoryConfig config, String path) {
  return config.allowedDirectories.any((allowed) => path.contains(allowed));
}
