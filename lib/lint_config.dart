class LintConfig {
  LintConfig(this.directoryConfigs);

  final List<LintDirectoryConfig> directoryConfigs;
}

class LintDirectoryConfig {
  LintDirectoryConfig(
    this.directory,
    this.allowedDirectories,
    this.allowedSameDirectory,
  );

  final String directory;
  final List<String> allowedDirectories;
  final bool allowedSameDirectory;
}
