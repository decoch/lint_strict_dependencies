import 'package:lint_strict_dependencies/file_entity.dart';
import 'package:lint_strict_dependencies/lint_config.dart';
import 'package:lint_strict_dependencies/lint_file.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('lintFile', () {
    final config = LintConfig(
      [
        'lib',
      ],
      [
        LintDirectoryConfig(
          'widgets',
          [
            'screens',
          ],
          true,
        ),
        LintDirectoryConfig(
          'domain',
          [
            'use_case',
            'infra',
          ],
          false,
        ),
      ],
    );

    test('success when valid import', () {
      final result = lintFile(
        config,
        'dummy_package',
        _FileEntityMock(
          '/tmp/lint_strict_dependencies/use_case/dummy_use_case.dart',
          [
            'import \'package:flutter/flutter/dummy.dart\';',
            'import \'package:dummy_package/domain/dummy_domain.dart\';',
          ],
        ),
      );
      expect(result, isNull);
    });

    test('success when not target', () {
      final result = lintFile(
        config,
        'dummy_package',
        _FileEntityMock(
          '/tmp/lint_strict_dependencies/use_case/dummy_use_case.dart',
          [
            'import \'package:flutter/flutter/dummy.dart\';',
            'import \'package:dummy_package/infra/dummy_infra.dart\';',
          ],
        ),
      );
      expect(result, isNull);
    });

    test('fail when invalid import', () {
      final result = lintFile(
        config,
        'dummy_package',
        _FileEntityMock(
          '/tmp/lint_strict_dependencies/screen/dummy_screen.dart',
          [
            'import \'package:flutter/flutter/dummy.dart\';',
            'import \'package:dummy_package/domain/dummy_domain.dart\';',
          ],
        ),
      );
      expect(result, isNotNull);
    });
    test('fail when not allowed same directory', () {
      final result = lintFile(
        config,
        'dummy_package',
        _FileEntityMock(
          '/tmp/lint_strict_dependencies/domain/dummy_import_domain.dart',
          [
            'import \'package:flutter/flutter/dummy.dart\';',
            'import \'package:dummy_package/domain/dummy_domain.dart\';',
          ],
        ),
      );
      expect(result, isNotNull);
    });
  });
}

class _FileEntityMock implements FileEntity {
  _FileEntityMock(this.path, this.lines);

  final String path;
  final List<String> lines;

  @override
  List<String> readAsLinesSync() {
    return lines;
  }
}
