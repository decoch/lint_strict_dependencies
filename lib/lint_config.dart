class LintConfig {
  LintConfig(
    this.targetDirectories,
    this.directoryConfigs,
  );

  final List<String> targetDirectories;
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
