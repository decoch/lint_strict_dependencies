import 'package:lint_strict_dependencies/file_entity.dart';
import 'package:lint_strict_dependencies/lint_config.dart';
import 'package:lint_strict_dependencies/lint_error.dart';

LintError? lintFile(LintConfig config, String packageName, FileEntity file) {
  final lines = file.readAsLinesSync();
  for (var i = 0; i < lines.length; i++) {
    final line = lines[i];
    if (line.startsWith('import ') && line.endsWith(';')) {
      if (line.contains('package:$packageName/')) {
        final error = _lintLine(config, packageName, file.path, line);
        if (error) {
          return LintError('dummy', []);
        }
      }
    }
  }
  return null;
}

bool _lintLine(
  LintConfig config,
  String packageName,
  String path,
  String line,
) {
  if (!line.contains(packageName)) {
    return false;
  }
  return config.directoryConfigs
      .where((directoryConfig) => line.contains(directoryConfig.directory))
      .where(
        (directoryConfig) => !directoryConfig.allowedDirectories.any(
          (allowed) => path.contains(allowed),
        ),
      )
      .isNotEmpty;
}
