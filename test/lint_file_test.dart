import 'package:lint_strict_dependencies/file_entity.dart';
import 'package:lint_strict_dependencies/file_linter.dart';
import 'package:lint_strict_dependencies/line_linter.dart';
import 'package:lint_strict_dependencies/lint_config.dart';
import 'package:lint_strict_dependencies/lint_error.dart';
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
    final linter = FileLinter(
      lineLinter: LineLinter(
        config: config,
        packageName: 'dummy_package',
      ),
    );

    test('success when valid import', () {
      linter.lint(
        _FileEntityMock(
          '/tmp/lint_strict_dependencies/use_case/dummy_use_case.dart',
          [
            'import \'package:flutter/flutter/dummy.dart\';',
            'import \'package:dummy_package/domain/dummy_domain.dart\';',
          ],
        ),
      );
    });

    test('success when not target', () {
      linter.lint(
        _FileEntityMock(
          '/tmp/lint_strict_dependencies/use_case/dummy_use_case.dart',
          [
            'import \'package:flutter/flutter/dummy.dart\';',
            'import \'package:dummy_package/infra/dummy_infra.dart\';',
          ],
        ),
      );
    });

    test('fail when invalid import', () {
      try {
        linter.lint(
          _FileEntityMock(
            '/tmp/lint_strict_dependencies/screen/dummy_screen.dart',
            [
              'import \'package:flutter/flutter/dummy.dart\';',
              'import \'package:dummy_package/domain/dummy_domain.dart\';',
            ],
          ),
        );
        fail('this test should throw error');
      } on LintError {}
    });
    test('fail when not allowed same directory', () {
      try {
        linter.lint(
          _FileEntityMock(
            '/tmp/lint_strict_dependencies/domain/dummy_import_domain.dart',
            [
              'import \'package:flutter/flutter/dummy.dart\';',
              'import \'package:dummy_package/domain/dummy_domain.dart\';',
            ],
          ),
        );
        fail('this test should throw error');
      } on LintError {}
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
