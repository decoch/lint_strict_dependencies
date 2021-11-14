import 'dart:io';

class FileEntity {
  FileEntity(this.path, this.file);

  final String path;
  final File file;

  List<String> readAsLinesSync() {
    return file.readAsLinesSync();
  }
}
