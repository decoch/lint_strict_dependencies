class LintError {
  LintError(this.file, this.invalidImport);

  final String file;
  final List<String> invalidImport;
}
