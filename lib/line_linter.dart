import 'package:lint_strict_dependencies/lint_config.dart';
import 'package:lint_strict_dependencies/lint_error.dart';

class LineLinter {
  final LintConfig config;
  final String packageName;

  LineLinter({
    required this.config,
    required this.packageName,
  });

  void lint(String filePath, String line) {
    if (!_isTargetImport(line)) {
      return;
    }

    final invalidImports = _extractInvalidImports(
      config,
      packageName,
      filePath,
      line,
    );
    if (invalidImports.isNotEmpty) {
      throw LintError(filePath, line);
    }
  }

  bool _isTargetImport(String line) {
    return line.startsWith('import ') &&
        line.endsWith(';') &&
        line.contains('package:$packageName/');
  }

  List<String> _extractInvalidImports(
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
}
