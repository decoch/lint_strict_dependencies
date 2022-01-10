import 'package:lint_strict_dependencies/file_entity.dart';
import 'package:lint_strict_dependencies/line_linter.dart';

class FileLinter {
  final LineLinter lineLinter;

  FileLinter({
    required this.lineLinter,
  });

  void lint(FileEntity file) {
    final lines = file.readAsLinesSync();
    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      lineLinter.lint(file.path, line);
    }
    return null;
  }
}
